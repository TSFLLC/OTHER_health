
/*
Per-Table Copy & Tokenize Template (T-SQL only)
Replace placeholders and run ad-hoc or inside a job step.
*/
USE [YourNonProdDb];
GO
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N'YourProdDb',
    @SourceSchema=N'dbo',
    @SourceTable=N'<TABLE_NAME>',
    @TargetSchema=N'dbo',
    @TargetTable=N'<TABLE_NAME>',
    @TokenizeColumns=N'<CSV_OF_COLUMNS_TO_TOKENIZE>';  -- e.g., N'Email,Phone,MRN'
GO
