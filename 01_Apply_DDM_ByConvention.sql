
/*
===============================================================================
01_Apply_DDM_ByConvention.sql
Purpose  : Apply Dynamic Data Masking (DDM) using name-based conventions.
Target   : CURRENT DATABASE
Safety   : Idempotent-ish; only applies to columns not already masked where possible.
Prereqs  : Requires ALTER permission on target tables/columns.
Notes    : Review the mapping table and adjust to your environment before running.
===============================================================================
*/

SET NOCOUNT ON;
GO

/* Mapping of name pattern -> DDM function */
IF OBJECT_ID('tempdb..#DDM_Map') IS NOT NULL DROP TABLE #DDM_Map;
CREATE TABLE #DDM_Map (
    Pattern       nvarchar(100) NOT NULL,
    DdmFunction   nvarchar(200) NOT NULL,
    Example       nvarchar(200) NULL
);
INSERT INTO #DDM_Map(Pattern, DdmFunction, Example)
VALUES
    (N'email',           N'email()',                           N'user***@domain.com'),
    (N'phone',           N"partial(0,'XXX-XXX-',4)",           N'XXX-XXX-1234'),
    (N'telephone',       N"partial(0,'XXX-XXX-',4)",           N'XXX-XXX-1234'),
    (N'cell',            N"partial(0,'XXX-XXX-',4)",           N'XXX-XXX-1234'),
    (N'mobile',          N"partial(0,'XXX-XXX-',4)",           N'XXX-XXX-1234'),
    (N'ssn',             N"partial(0,'XXX-XX-',4)",            N'XXX-XX-1234'),
    (N'social_security', N"partial(0,'XXX-XX-',4)",            N'XXX-XX-1234'),
    (N'firstname',       N"partial(1,'***',0)",                N'J***'),
    (N'lastname',        N"partial(1,'***',0)",                N'D***'),
    (N'middlename',      N"partial(1,'***',0)",                N'M***'),
    (N'givenname',       N"partial(1,'***',0)",                N'G***'),
    (N'surname',         N"partial(1,'***',0)",                N'S***'),
    (N'full_name',       N"partial(1,'***',0)",                N'J***'),
    (N'address',         N"default()",                         N'REDACTED'),
    (N'street',          N"default()",                         N'REDACTED'),
    (N'apt',             N"default()",                         N'REDACTED'),
    (N'zipcode',         N"partial(3,'**',0)",                 N'770**'),
    (N'postalcode',      N"partial(3,'**',0)",                 N'770**'),
    (N'zip',             N"partial(3,'**',0)",                 N'770**'),
    (N'dob',             N"default()",                         N'Hide exact date'),
    (N'dateofbirth',     N"default()",                         N'Hide exact date'),
    (N'birthdate',       N"default()",                         N'Hide exact date'),
    (N'mrn',             N"default()",                         N'TOKEN-*'),
    (N'patientid',       N"default()",                         N'TOKEN-*'),
    (N'memberid',        N"default()",                         N'TOKEN-*'),
    (N'subscriberid',    N"default()",                         N'TOKEN-*'),
    (N'personid',        N"default()",                         N'TOKEN-*'),
    (N'medicalrecord',   N"default()",                         N'TOKEN-*'),
    (N'diagnosis',       N"default()",                         N'Hide value'),
    (N'icd',             N"default()",                         N'Hide code'),
    (N'procedure',       N"default()",                         N'Hide value'),
    (N'cpt',             N"default()",                         N'Hide code'),
    (N'hcpcs',           N"default()",                         N'Hide code'),
    (N'loinc',           N"default()",                         N'Hide code'),
    (N'encounter',       N"default()",                         N'Hide value'),
    (N'visit',           N"default()",                         N'Hide value')
;

/* Build candidate set: columns not computed and not already masked */
IF OBJECT_ID('tempdb..#Candidates') IS NOT NULL DROP TABLE #Candidates;
SELECT 
    s.name  AS SchemaName,
    t.name  AS TableName,
    c.name  AS ColumnName,
    TYPE_NAME(c.user_type_id) AS DataType,
    c.max_length,
    c.is_nullable,
    c.column_id,
    CAST(0 AS bit) AS IsMaskedInitial
INTO #Candidates
FROM sys.tables t
JOIN sys.schemas s ON s.schema_id = t.schema_id
JOIN sys.columns c ON c.object_id = t.object_id
WHERE t.is_ms_shipped = 0
  AND c.is_computed = 0;

/* Flag columns already masked (SQL Server 2016+ keeps masking metadata) */
IF COL_LENGTH('sys.columns','is_masked') IS NOT NULL
BEGIN
    UPDATE c
    SET IsMaskedInitial = sc.is_masked
    FROM #Candidates c
    JOIN sys.columns sc
      ON sc.object_id = OBJECT_ID(QUOTENAME(c.SchemaName)+'.'+QUOTENAME(c.TableName))
     AND sc.name = c.ColumnName;
END

/* Generate ALTER statements for matches */
IF OBJECT_ID('tempdb..#DDM_SQL') IS NOT NULL DROP TABLE #DDM_SQL;
CREATE TABLE #DDM_SQL (
    SqlText nvarchar(max) NOT NULL
);

INSERT INTO #DDM_SQL(SqlText)
SELECT DISTINCT
    '/* ' + c.SchemaName + '.' + c.TableName + '.' + c.ColumnName + ' */' + CHAR(10) +
    'ALTER TABLE ' + QUOTENAME(c.SchemaName) + '.' + QUOTENAME(c.TableName) + CHAR(10) +
    '  ALTER COLUMN ' + QUOTENAME(c.ColumnName) + ' ' + 
        CASE 
            WHEN c.DataType IN ('nvarchar','varchar') 
                THEN c.DataType + CASE WHEN c.max_length = -1 THEN '(max)' ELSE '(' + CAST(CASE WHEN c.max_length<0 THEN 0 ELSE c.max_length END/CASE WHEN c.DataType LIKE '%nvar%' THEN 2 ELSE 1 END AS varchar(10)) + ')' END
            WHEN c.DataType IN ('char','nchar') 
                THEN c.DataType + '(' + CAST(CASE WHEN c.max_length<0 THEN 0 ELSE c.max_length END/CASE WHEN c.DataType='nchar' THEN 2 ELSE 1 END AS varchar(10)) + ')'
            WHEN c.DataType IN ('datetime','datetime2','date','time') THEN c.DataType
            WHEN c.DataType IN ('bigint','int','smallint','tinyint','bit','decimal','numeric','money','smallmoney','float','real') THEN c.DataType + COALESCE('','')
            ELSE c.DataType
        END + ' ' +
        CASE WHEN c.is_nullable=1 THEN 'NULL' ELSE 'NOT NULL' END + ' MASKED WITH (FUNCTION = ''' + m.DdmFunction + ''');' + CHAR(10) +
    'GO' + CHAR(10)
FROM #Candidates c
JOIN #DDM_Map m
  ON LOWER(c.ColumnName) LIKE '%' + LOWER(m.Pattern) + '%'
WHERE c.IsMaskedInitial = 0;

/* Review first */
SELECT TOP (200) * FROM #DDM_SQL;

/* Uncomment to EXECUTE automatically
DECLARE @sql nvarchar(max);
DECLARE cur CURSOR LOCAL FAST_FORWARD FOR SELECT SqlText FROM #DDM_SQL;
OPEN cur;
FETCH NEXT FROM cur INTO @sql;
WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT LEFT(@sql, 4000);
    EXEC(@sql);
    FETCH NEXT FROM cur INTO @sql;
END
CLOSE cur;
DEALLOCATE cur;
*/

PRINT 'DDM generation complete. Review #DDM_SQL contents before executing.';
