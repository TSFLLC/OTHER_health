
# 03b_NonProd_Copy_Tokenize.ps1
# Purpose: Orchestrate PROD -> NON-PROD copy with tokenization using Invoke-Sqlcmd.
# Requirements: SqlServer module; Tokenization_Schema.sql and 03_NonProd_Copy_Tokenize.sql deployed on NON-PROD.

param(
  [string]$ProdServer   = "PROD-SQL01",
  [string]$ProdDb       = "YourProdDb",
  [string]$NonProdServer= "DEV-SQL01",
  [string]$NonProdDb    = "YourDevDb",
  [string]$Schema       = "dbo",
  [string]$Table        = "YourTable"
)

Import-Module SqlServer -ErrorAction Stop

# Example: use linked server or staged export. Here we assume NON-PROD has linked server [PROD].
# Deploy helper proc if needed:
# Invoke-Sqlcmd -ServerInstance $NonProdServer -Database $NonProdDb -InputFile "03_NonProd_Copy_Tokenize.sql"

# Execute copy + tokenize
$tsql = @"
EXEC dbo.usp_CopyAndTokenize
    @SourceDb     = N'$ProdDb',
    @SourceSchema = N'$Schema',
    @SourceTable  = N'$Table',
    @TargetSchema = N'$Schema',
    @TargetTable  = N'$Table';
"@

Invoke-Sqlcmd -ServerInstance $NonProdServer -Database $NonProdDb -Query $tsql -Verbose
Write-Host "Copy & tokenize completed for $Schema.$Table"
