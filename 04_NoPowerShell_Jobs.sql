
/*
================================================================================
Automated Non-Prod Sync WITH Tokenization - NO PowerShell
Environment: SQL Server On-Prem
Approach   : SQL Server Agent + T-SQL only (linked server to PROD)
================================================================================

1) Prereqs:
   - Linked server to PROD (example name: [PROD])
     EXEC master.dbo.sp_addlinkedserver @server = N'PROD', @srvproduct=N'SQL Server';
     -- Configure security:
     EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'PROD', @useself='False',
         @locallogin=NULL, @rmtuser=N'<prod_login>', @rmtpassword=N'<prod_password>';

   - Tokenization framework deployed in NON-PROD:
     Run Tokenization_Schema.sql (tok schema, TokenMap, TokenDomain, Upsert proc).

   - Optional: HIPAA masking matrix guides column-level treatment.

2) This script will create:
   - Logging table: sec.JobRunLog
   - Helper proc: dbo.usp_CopyAndTokenize_NoPS (pure T-SQL)
   - SQL Agent Job: Job_CopyAndTokenize_<Schema>_<Table> (nightly schedule)
================================================================================
*/

USE [YourNonProdDb];  -- <-- change to your NON-PROD database
GO

/* SEC schema for logs if not exists */
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'sec')
    EXEC('CREATE SCHEMA sec AUTHORIZATION dbo;');
GO

/* Basic job run log */
IF OBJECT_ID('sec.JobRunLog','U') IS NULL
BEGIN
    CREATE TABLE sec.JobRunLog (
        JobRunLogID  bigint IDENTITY(1,1) PRIMARY KEY,
        ProcName     sysname       NOT NULL,
        SchemaName   sysname       NOT NULL,
        TableName    sysname       NOT NULL,
        StartedAt    datetime2(0)  NOT NULL DEFAULT (sysutcdatetime()),
        EndedAt      datetime2(0)  NULL,
        RowsInserted bigint        NULL,
        RowsUpdated  bigint        NULL,
        RowsTokenized bigint       NULL,
        Status       varchar(20)   NULL,
        Message      nvarchar(4000) NULL
    );
END
GO

/* Tokenize one column by calling tok.UpsertToken for each value */
IF OBJECT_ID('dbo.usp_TokenizeColumn','P') IS NOT NULL
    DROP PROCEDURE dbo.usp_TokenizeColumn;
GO
CREATE PROCEDURE dbo.usp_TokenizeColumn
    @SchemaName sysname,
    @TableName  sysname,
    @ColumnName sysname
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @DomainID int;
    IF NOT EXISTS (
        SELECT 1 FROM tok.TokenDomain
        WHERE SchemaName=@SchemaName AND TableName=@TableName AND ColumnName=@ColumnName
    )
    BEGIN
        INSERT INTO tok.TokenDomain(SchemaName,TableName,ColumnName)
        VALUES(@SchemaName,@TableName,@ColumnName);
    END

    -- Update in place with deterministic tokens
    ;WITH S AS (
        SELECT DISTINCT CAST([val] AS nvarchar(4000)) AS SourceValue
        FROM (
            SELECT TOP (2147483647) -- guard
                   CASE 
                       WHEN SQL_VARIANT_PROPERTY(CASE WHEN TRY_CONVERT(nvarchar(4000),T.c) IS NOT NULL THEN TRY_CONVERT(nvarchar(4000),T.c) END, 'BaseType') IS NULL
                       THEN TRY_CONVERT(nvarchar(4000),T.c)
                       ELSE TRY_CONVERT(nvarchar(4000),T.c)
                   END AS [val]
            FROM (
                SELECT DISTINCT 'x' AS d -- placeholder
            ) d
        ) v
    )
    -- The above is a placeholder because we cannot dynamically reference the table in a CTE without dynamic SQL.
    -- We'll use dynamic SQL below for the UPDATE.
    DECLARE @sql nvarchar(max) = N'
    DECLARE @SchemaName sysname = @pSchema, @TableName sysname = @pTable, @ColumnName sysname = @pCol;
    DECLARE @DomainID int;
    SELECT @DomainID = TokenDomainID
    FROM tok.TokenDomain
    WHERE SchemaName=@SchemaName AND TableName=@TableName AND ColumnName=@ColumnName;

    ;WITH U AS (
        SELECT DISTINCT CAST(' + QUOTENAME(@SchemaName) + N'.' + QUOTENAME(@TableName) + N'.' + QUOTENAME(@ColumnName) + N' AS nvarchar(4000)) AS SourceValue
        FROM ' + QUOTENAME(@SchemaName) + N'.' + QUOTENAME(@TableName) + N'
        WHERE ' + QUOTENAME(@ColumnName) + N' IS NOT NULL
    )
    MERGE tok.TokenMap AS tm
    USING (
        SELECT @DomainID AS TokenDomainID, HASHBYTES(''SHA2_256'', SourceValue) AS SourceHash
        FROM U
    ) AS s
    ON tm.TokenDomainID = s.TokenDomainID AND tm.SourceHash = s.SourceHash
    WHEN NOT MATCHED THEN
        INSERT(TokenDomainID, SourceHash, TokenValue)
        VALUES(s.TokenDomainID, s.SourceHash, CONCAT(''TKN-'', FORMAT(NEXT VALUE FOR tok.TokenSeq, ''000000'')))
    OUTPUT $action; -- for debugging

    UPDATE T
       SET ' + QUOTENAME(@ColumnName) + N' = tm.TokenValue
      FROM ' + QUOTENAME(@SchemaName) + N'.' + QUOTENAME(@TableName) + N' AS T
      CROSS APPLY (SELECT HASHBYTES(''SHA2_256'', CAST(' + QUOTENAME(@ColumnName) + N' AS nvarchar(4000))) AS H) h
      JOIN tok.TokenMap tm
        ON tm.TokenDomainID = @DomainID
       AND tm.SourceHash = h.H;
    ';

    EXEC sp_executesql @sql,
        N'@pSchema sysname, @pTable sysname, @pCol sysname',
        @pSchema=@SchemaName, @pTable=@TableName, @pCol=@ColumnName;
END
GO

/* Main copy + tokenize proc (no PowerShell) */
IF OBJECT_ID('dbo.usp_CopyAndTokenize_NoPS','P') IS NOT NULL
    DROP PROCEDURE dbo.usp_CopyAndTokenize_NoPS;
GO
CREATE PROCEDURE dbo.usp_CopyAndTokenize_NoPS
    @SourceDb sysname,
    @SourceSchema sysname,
    @SourceTable sysname,
    @TargetSchema sysname,
    @TargetTable sysname,
    @TokenizeColumns nvarchar(max) = N'' -- CSV list, e.g. N'Email,Phone,MRN'
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @logId bigint;
    INSERT INTO sec.JobRunLog(ProcName,SchemaName,TableName,Status,Message)
    VALUES(OBJECT_NAME(@@PROCID),@TargetSchema,@TargetTable,'START','');
    SET @logId = SCOPE_IDENTITY();

    BEGIN TRY
        DECLARE @src nvarchar(512) = QUOTENAME(@SourceDb) + '.' + QUOTENAME(@SourceSchema) + '.' + QUOTENAME(@SourceTable);
        DECLARE @tgt nvarchar(512) = QUOTENAME(@TargetSchema) + '.' + QUOTENAME(@TargetTable);

        -- 1) Truncate target and load from PROD via linked server
        DECLARE @sql nvarchar(max) =
            N'TRUNCATE TABLE ' + @tgt + ';' + CHAR(10) +
            N'INSERT INTO ' + @tgt + ' SELECT * FROM [PROD].' + @src + ';';
        EXEC(@sql);

        -- 2) Tokenize listed columns
        DECLARE @col sysname, @pos int = 1, @csv nvarchar(max) = @TokenizeColumns + N',';
        WHILE CHARINDEX(',', @csv, @pos) > 0
        BEGIN
            DECLARE @next int = CHARINDEX(',', @csv, @pos);
            SET @col = LTRIM(RTRIM(SUBSTRING(@csv, @pos, @next - @pos)));
            SET @pos = @next + 1;
            IF @col <> N''
                EXEC dbo.usp_TokenizeColumn @TargetSchema, @TargetTable, @col;
        END

        UPDATE sec.JobRunLog
           SET EndedAt = sysutcdatetime(),
               Status  = 'SUCCESS'
         WHERE JobRunLogID = @logId;
    END TRY
    BEGIN CATCH
        UPDATE sec.JobRunLog
           SET EndedAt = sysutcdatetime(),
               Status  = 'FAIL',
               Message = CONCAT('Error: ', ERROR_MESSAGE())
         WHERE JobRunLogID = @logId;
        THROW;
    END CATCH
END
GO

/* --------------------------------------------------------------------------
   OPTIONAL: Create a SQL Agent Job (no PowerShell) for one table.
   Replace placeholders and run on NON-PROD server.
-------------------------------------------------------------------------- */
DECLARE 
    @jobname sysname = N'Job_CopyAndTokenize_dbo_Patient',
    @scheduleName sysname = N'Sched_Nightly_1AM',
    @command nvarchar(max);

-- Create job
IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize from PROD to NON-PROD (T-SQL only)';
END

-- Add job step that calls the proc with CSV of columns to tokenize
SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''dbo'',
    @SourceTable=N''Patient'',
    @TargetSchema=N''dbo'',
    @TargetTable=N''Patient'',
    @TokenizeColumns=N''Email,Phone,MRN'';
';

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobsteps WHERE step_name = N'S1_CopyAndTokenize' AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,  -- Quit with success
        @on_fail_action=2;     -- Quit with failure
END

-- Schedule (daily 1:00 AM)
IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,      -- daily
        @freq_interval=1,
        @active_start_time=010000; -- 01:00
END

-- Attach job to schedule and server
EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
EXEC msdb.dbo.sp_add_jobserver   @job_name=@jobname, @server_name = @@SERVERNAME;
GO

PRINT 'Non-PowerShell automation templates created. Edit placeholders and execute on NON-PROD.';
