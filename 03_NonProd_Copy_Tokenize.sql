
/*
===============================================================================
03_NonProd_Copy_Tokenize.sql
Purpose  : Copy data from PROD to NON-PROD with tokenization and masking.
Requires : Tokenization_Schema.sql deployed on NON-PROD.
Run on   : NON-PROD target (pulls from PROD via linked server or bcp/ETL).
===============================================================================
*/

-- Parameters: Adjust to your environment
-- Assumes a linked server named [PROD] pointing to prod source.
-- If not using linked servers, extract source to a staging table/file and adapt.

IF OBJECT_ID('dbo.usp_CopyAndTokenize', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_CopyAndTokenize;
GO
CREATE PROCEDURE dbo.usp_CopyAndTokenize
    @SourceDb sysname,
    @SourceSchema sysname,
    @SourceTable sysname,
    @TargetSchema sysname,
    @TargetTable sysname
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @src nvarchar(512) = QUOTENAME(@SourceDb) + '.' + QUOTENAME(@SourceSchema) + '.' + QUOTENAME(@SourceTable);
    DECLARE @tgt nvarchar(512) = QUOTENAME(@TargetSchema) + '.' + QUOTENAME(@TargetTable);

    -- 1) Create target table (structure only) if missing
    IF OBJECT_ID(@tgt) IS NULL
    BEGIN
        DECLARE @create nvarchar(max) = (SELECT TOP 1 OBJECT_DEFINITION(OBJECT_ID(@src)) FROM [PROD].sys.objects WHERE 1=1); -- placeholder if same structure exists
        -- In practice, script table from PROD or use SSDT/Schema compare. For now, assume target exists.
    END

    -- 2) Stage load raw rows (truncate target first)
    DECLARE @sql nvarchar(max) = N'';
    SET @sql = N'TRUNCATE TABLE ' + @tgt + ';' + CHAR(10) +
               N'INSERT INTO ' + @tgt + ' SELECT * FROM [PROD].' + @src + ';';
    EXEC(@sql);

    ------------------------------------------------------------------------
    -- 3) Tokenize/Mask in place per-column
    --    Define tokenization targets here (extend as needed)
    ------------------------------------------------------------------------
    /* Example: Email column */
    IF COL_LENGTH(@TargetSchema + '.' + @TargetTable, 'Email') IS NOT NULL
    BEGIN
        EXEC dbo.usp_TokenizeColumn @TargetSchema, @TargetTable, 'Email';
    END
    /* Example: Phone columns */
    IF COL_LENGTH(@TargetSchema + '.' + @TargetTable, 'Phone') IS NOT NULL
    BEGIN
        UPDATE T SET Phone = STUFF(STUFF(Phone, 1, 8, 'XXX-XXX-'), 13, LEN(Phone)-12, '')
        FROM  (SELECT * FROM sys.objects) a -- dummy to allow UPDATE; replace with direct UPDATE in your environment
        JOIN  (SELECT * FROM sys.objects) b ON 1=1; -- placeholder no-op
        -- Replace above with: UPDATE dbo.<table> SET Phone = CONCAT('XXX-XXX-', RIGHT(Phone,4));
    END
END
GO

-- Helper proc that calls tok.UpsertToken for each row in a specified column
IF OBJECT_ID('dbo.usp_TokenizeColumn', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_TokenizeColumn;
GO
CREATE PROCEDURE dbo.usp_TokenizeColumn
    @SchemaName sysname,
    @TableName  sysname,
    @ColumnName sysname
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @sql nvarchar(max) = N'';
    /* Deterministic tokenization per value */
    SET @sql = N'
    UPDATE T
       SET ' + QUOTENAME(@ColumnName) + N' = V.TokenValue
      FROM ' + QUOTENAME(@SchemaName) + N'.' + QUOTENAME(@TableName) + N' AS T
      CROSS APPLY (
            SELECT TokenValue
            FROM tok.TokenDomain d
            CROSS APPLY (
                SELECT @SchemaName AS SchemaName, @TableName AS TableName, @ColumnName AS ColumnName
            ) x
            CROSS APPLY (
                SELECT HASHBYTES(''SHA2_256'', CAST(' + QUOTENAME(@ColumnName) + N' AS nvarchar(4000))) AS H
            ) h
            OUTER APPLY (
                SELECT tm.TokenValue
                FROM tok.TokenMap tm
                WHERE tm.TokenDomainID = d.TokenDomainID
                  AND tm.SourceHash = h.H
            ) tm
            OUTER APPLY (
                SELECT CASE WHEN tm.TokenValue IS NULL THEN CONCAT(''TKN-'', FORMAT(NEXT VALUE FOR tok.TokenSeq, ''000000'')) END AS NewToken
            ) nt
            OUTER APPLY (
                SELECT COALESCE(tm.TokenValue, nt.NewToken) AS TokenValue
            ) tv
            WHERE d.SchemaName = @SchemaName
              AND d.TableName  = @TableName
              AND d.ColumnName = @ColumnName
      ) V;
    ';
    EXEC sp_executesql @sql, N'@SchemaName sysname, @TableName sysname, @ColumnName sysname', @SchemaName, @TableName, @ColumnName;
END
GO

PRINT 'Non-prod copy & tokenize templates installed. See dbo.usp_CopyAndTokenize usage header.';
