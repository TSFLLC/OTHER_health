-- =============================================================
-- Tokenization SCHEMA for Non-Prod (Surrogate Token Map)
-- Deterministic tokenization using a per-domain sequence;
-- source values are hashed (SHA2_256) for privacy.
-- =============================================================
GO
CREATE SCHEMA tok AUTHORIZATION dbo;
GO

CREATE SEQUENCE tok.TokenSeq AS bigint START WITH 100000 INCREMENT BY 1;
GO

CREATE TABLE tok.TokenDomain (
  TokenDomainID int IDENTITY(1,1) PRIMARY KEY,
  SchemaName    sysname NOT NULL,
  TableName     sysname NOT NULL,
  ColumnName    sysname NOT NULL,
  IsDeterministic bit NOT NULL DEFAULT(1),
  UNIQUE (SchemaName, TableName, ColumnName)
);
GO

CREATE TABLE tok.TokenMap (
  TokenDomainID int NOT NULL FOREIGN KEY REFERENCES tok.TokenDomain(TokenDomainID),
  SourceHash    varbinary(32) NOT NULL,  -- HASHBYTES('SHA2_256', SourceValue)
  TokenValue    nvarchar(128) NOT NULL,  -- e.g., 'TKN-000001'
  CreatedAt     datetime2 NOT NULL DEFAULT(sysutcdatetime()),
  CreatedBy     sysname NOT NULL DEFAULT(SUSER_SNAME()),
  CONSTRAINT PK_TokenMap PRIMARY KEY (TokenDomainID, SourceHash)
);
GO

CREATE OR ALTER PROCEDURE tok.UpsertToken
  @SchemaName sysname, @TableName sysname, @ColumnName sysname, @SourceValue nvarchar(4000),
  @TokenValue nvarchar(128) OUTPUT
AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @DomainID int;
  SELECT @DomainID = TokenDomainID
  FROM tok.TokenDomain
  WHERE SchemaName=@SchemaName AND TableName=@TableName AND ColumnName=@ColumnName;
  IF @DomainID IS NULL
  BEGIN
    INSERT INTO tok.TokenDomain(SchemaName,TableName,ColumnName)
    VALUES(@SchemaName,@TableName,@ColumnName);
    SET @DomainID = SCOPE_IDENTITY();
  END
  DECLARE @H varbinary(32) = HASHBYTES('SHA2_256', @SourceValue);
  SELECT @TokenValue = TokenValue
  FROM tok.TokenMap WHERE TokenDomainID=@DomainID AND SourceHash=@H;
  IF @TokenValue IS NULL
  BEGIN
    DECLARE @n bigint = NEXT VALUE FOR tok.TokenSeq;
    SET @TokenValue = CONCAT('TKN-', FORMAT(@n,'000000'));
    INSERT INTO tok.TokenMap(TokenDomainID,SourceHash,TokenValue)
    VALUES(@DomainID,@H,@TokenValue);
  END
END
GO

-- Example: batch tokenization template for a specific column
-- UPDATE t
--   SET SensitiveCol = v.TokenValue
-- FROM [schema].[table] t
-- CROSS APPLY (
--   SELECT TokenValue FROM OPENQUERY([LOCALSERVER], 'exec tok.UpsertToken ''schema'',''table'',''SensitiveCol'', ''' + REPLACE(t.SensitiveCol, '''', '''''') + '''') as tv(TokenValue)
-- ) v;
-- (Adjust to your environment; or loop/apply via ETL.)