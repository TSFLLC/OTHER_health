
/*
===============================================================================
02_Role_Grants_Template.sql
Purpose  : Wire security roles to AD groups or SQL users.
Target   : CURRENT DATABASE
Action   : Replace placeholders with your directory group or user names.
===============================================================================
*/

-- Example AD groups / users (replace with real principals):
DECLARE @Clinicians  sysname = N'[YOURDOMAIN\GG_DB_Clinicians]';
DECLARE @BIReaders   sysname = N'[YOURDOMAIN\GG_DB_BI_Readers]';
DECLARE @Analysts    sysname = N'[YOURDOMAIN\GG_DB_Analysts]';

-- Create roles if not already created (from RLS_Templates.sql)
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'role_Clinician_FullPHI')
    CREATE ROLE role_Clinician_FullPHI;
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'role_BI_Reader_Masked')
    CREATE ROLE role_BI_Reader_Masked;
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'role_Analyst_Restricted')
    CREATE ROLE role_Analyst_Restricted;

-- Add members
DECLARE @sql nvarchar(max) = N'';
SET @sql += N'ALTER ROLE role_Clinician_FullPHI ADD MEMBER ' + @Clinicians + ';' + CHAR(10);
SET @sql += N'ALTER ROLE role_BI_Reader_Masked ADD MEMBER ' + @BIReaders  + ';' + CHAR(10);
SET @sql += N'ALTER ROLE role_Analyst_Restricted ADD MEMBER ' + @Analysts   + ';' + CHAR(10);
PRINT @sql;
-- EXEC(@sql);  -- uncomment to apply

-- Minimal privileges (tighten to your environment)
-- Grant SELECT to masked readers; Clinicians may need broader access.
GRANT SELECT ON SCHEMA::dbo TO role_BI_Reader_Masked;
GRANT SELECT ON SCHEMA::dbo TO role_Analyst_Restricted;
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::dbo TO role_Clinician_FullPHI;

PRINT 'Role grant statements prepared. Replace placeholders and EXEC as needed.';
