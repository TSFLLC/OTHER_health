
/*
===============================================================================
05_Create_Jobs_From_Matrix.sql
Purpose  : Auto-create SQL Agent jobs per table for Prod -> Non-Prod copy with tokenization
Requires : 04_NoPowerShell_Jobs.sql deployed (procs + schedule helper + linked server to PROD)
Target   : NON-PROD server
Edit     : Replace YourNonProdDb / YourProdDb; review job names and schedules.
===============================================================================
*/

-- ---------------------------------------------------------------------------
-- B_cdc.NHSN_HAI
-- Columns to tokenize: CCN,NHSN,SourceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_cdc_NHSN_HAI';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_cdc.NHSN_HAI from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_cdc'',
    @SourceTable=N''NHSN_HAI'',
    @TargetSchema=N''B_cdc'',
    @TargetTable=N''NHSN_HAI'',
    @TokenizeColumns=N''CCN,NHSN,SourceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_common.Date
-- Columns to tokenize: HolidayName,IsHoliday
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_common_Date';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_common.Date from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_common'',
    @SourceTable=N''Date'',
    @TargetSchema=N''B_common'',
    @TargetTable=N''Date'',
    @TokenizeColumns=N''HolidayName,IsHoliday'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_common.SourceSystem
-- Columns to tokenize: ID
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_common_SourceSystem';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_common.SourceSystem from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_common'',
    @SourceTable=N''SourceSystem'',
    @TargetSchema=N''B_common'',
    @TargetTable=N''SourceSystem'',
    @TokenizeColumns=N''ID'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_edw.Facility
-- Columns to tokenize: CategoryId,FacilityId,MktId3,SourceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_edw_Facility';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_edw.Facility from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_edw'',
    @SourceTable=N''Facility'',
    @TargetSchema=N''B_edw'',
    @TargetTable=N''Facility'',
    @TokenizeColumns=N''CategoryId,FacilityId,MktId3,SourceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_epic.BillArea
-- Columns to tokenize: Billareaid,Findivid,Finsubdivid,SourceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_epic_BillArea';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_epic.BillArea from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_epic'',
    @SourceTable=N''BillArea'',
    @TargetSchema=N''B_epic'',
    @TargetTable=N''BillArea'',
    @TokenizeColumns=N''Billareaid,Findivid,Finsubdivid,SourceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_epic.CPTCode
-- Columns to tokenize: SourceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_epic_CPTCode';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_epic.CPTCode from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_epic'',
    @SourceTable=N''CPTCode'',
    @TargetSchema=N''B_epic'',
    @TargetTable=N''CPTCode'',
    @TokenizeColumns=N''SourceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_epic.ClCostCntr
-- Columns to tokenize: Costcntrid,SourceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_epic_ClCostCntr';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_epic.ClCostCntr from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_epic'',
    @SourceTable=N''ClCostCntr'',
    @TargetSchema=N''B_epic'',
    @TargetTable=N''ClCostCntr'',
    @TokenizeColumns=N''Costcntrid,SourceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_epic.ClarityBed
-- Columns to tokenize: Bedcsnid,Bedid,Bedlabel,Cmlogownerid,Cmphyownerid,Roomid,SourceId,Telephonenumber
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_epic_ClarityBed';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_epic.ClarityBed from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_epic'',
    @SourceTable=N''ClarityBed'',
    @TargetSchema=N''B_epic'',
    @TargetTable=N''ClarityBed'',
    @TokenizeColumns=N''Bedcsnid,Bedid,Bedlabel,Cmlogownerid,Cmphyownerid,Roomid,SourceId,Telephonenumber'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_epic.ClarityDep
-- Columns to tokenize: Adtparentid,Departmentid,Revlocid,Servareaid,SourceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_epic_ClarityDep';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_epic.ClarityDep from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_epic'',
    @SourceTable=N''ClarityDep'',
    @TargetSchema=N''B_epic'',
    @TargetTable=N''ClarityDep'',
    @TokenizeColumns=N''Adtparentid,Departmentid,Revlocid,Servareaid,SourceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_epic.ClarityLoc
-- Columns to tokenize: Facilityid,Locid,Servareaid,SourceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_epic_ClarityLoc';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_epic.ClarityLoc from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_epic'',
    @SourceTable=N''ClarityLoc'',
    @TargetSchema=N''B_epic'',
    @TargetTable=N''ClarityLoc'',
    @TokenizeColumns=N''Facilityid,Locid,Servareaid,SourceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_epic.ClarityPos
-- Columns to tokenize: Addressline1,Addressline2,Posid,SourceId,Zip
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_epic_ClarityPos';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_epic.ClarityPos from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_epic'',
    @SourceTable=N''ClarityPos'',
    @TargetSchema=N''B_epic'',
    @TargetTable=N''ClarityPos'',
    @TokenizeColumns=N''Addressline1,Addressline2,Posid,SourceId,Zip'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_epic.ClarityRom
-- Columns to tokenize: Cmlogownerid,Cmphyownerid,Departmentid,Roomcsnid,Roomid,SourceId,Stationid
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_epic_ClarityRom';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_epic.ClarityRom from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_epic'',
    @SourceTable=N''ClarityRom'',
    @TargetSchema=N''B_epic'',
    @TargetTable=N''ClarityRom'',
    @TokenizeColumns=N''Cmlogownerid,Cmphyownerid,Departmentid,Roomcsnid,Roomid,SourceId,Stationid'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_epic.ClaritySa
-- Columns to tokenize: Servareaid,SourceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_epic_ClaritySa';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_epic.ClaritySa from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_epic'',
    @SourceTable=N''ClaritySa'',
    @TargetSchema=N''B_epic'',
    @TargetTable=N''ClaritySa'',
    @TokenizeColumns=N''Servareaid,SourceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_epic.ClaritySer
-- Columns to tokenize: Provid,SourceId,Userid
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_epic_ClaritySer';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_epic.ClaritySer from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_epic'',
    @SourceTable=N''ClaritySer'',
    @TargetSchema=N''B_epic'',
    @TargetTable=N''ClaritySer'',
    @TokenizeColumns=N''Provid,SourceId,Userid'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_epic.ClaritySer2
-- Columns to tokenize: Provid,SourceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_epic_ClaritySer2';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_epic.ClaritySer2 from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_epic'',
    @SourceTable=N''ClaritySer2'',
    @TargetSchema=N''B_epic'',
    @TargetTable=N''ClaritySer2'',
    @TokenizeColumns=N''Provid,SourceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_epic.ClaritySerAddr
-- Columns to tokenize: Addrcesetident,Addresschecksum,Addrlinklocid,Addrlinkorgid,Addrlocid,Addrposid,Addruniqueid,Cmlogownerid,Cmphyownerid,Cntctmthdruleid,Duplicateeafid,Email,Extaddrid,Internaladdressyn,Orgid,Phone,Provid,Serprinterid,Sharedaddressyn,SourceId,Vendorid,Zip
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_epic_ClaritySerAddr';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_epic.ClaritySerAddr from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_epic'',
    @SourceTable=N''ClaritySerAddr'',
    @TargetSchema=N''B_epic'',
    @TargetTable=N''ClaritySerAddr'',
    @TokenizeColumns=N''Addrcesetident,Addresschecksum,Addrlinklocid,Addrlinkorgid,Addrlocid,Addrposid,Addruniqueid,Cmlogownerid,Cmphyownerid,Cntctmthdruleid,Duplicateeafid,Email,Extaddrid,Internaladdressyn,Orgid,Phone,Provid,Serprinterid,Sharedaddressyn,SourceId,Vendorid,Zip'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_epic.Country
-- Columns to tokenize: SourceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_epic_Country';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_epic.Country from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_epic'',
    @SourceTable=N''Country'',
    @TargetSchema=N''B_epic'',
    @TargetTable=N''Country'',
    @TokenizeColumns=N''SourceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_epic.Disposition
-- Columns to tokenize: SourceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_epic_Disposition';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_epic.Disposition from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_epic'',
    @SourceTable=N''Disposition'',
    @TargetSchema=N''B_epic'',
    @TargetTable=N''Disposition'',
    @TokenizeColumns=N''SourceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_epic.EncounterType
-- Columns to tokenize: SourceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_epic_EncounterType';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_epic.EncounterType from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_epic'',
    @SourceTable=N''EncounterType'',
    @TargetSchema=N''B_epic'',
    @TargetTable=N''EncounterType'',
    @TokenizeColumns=N''SourceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_epic.Ethnicity
-- Columns to tokenize: SourceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_epic_Ethnicity';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_epic.Ethnicity from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_epic'',
    @SourceTable=N''Ethnicity'',
    @TargetSchema=N''B_epic'',
    @TargetTable=N''Ethnicity'',
    @TokenizeColumns=N''SourceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_epic.FactEncounter
-- Columns to tokenize: EncounterEpicCsn,EncounterKey,PatientKey,ProviderKey,SourceID
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_epic_FactEncounter';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_epic.FactEncounter from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_epic'',
    @SourceTable=N''FactEncounter'',
    @TargetSchema=N''B_epic'',
    @TargetTable=N''FactEncounter'',
    @TokenizeColumns=N''EncounterEpicCsn,EncounterKey,PatientKey,ProviderKey,SourceID'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_epic.FactReferral
-- Columns to tokenize: DiagnosisComboKey,FirstEncounterDateKey,FirstEncounterKey,HospitalChargeAmount,Patientkey,PrimaryDiagnosisKey,ReferralEpicId,ReferredToProviderSpecialty,SourceID
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_epic_FactReferral';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_epic.FactReferral from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_epic'',
    @SourceTable=N''FactReferral'',
    @TargetSchema=N''B_epic'',
    @TargetTable=N''FactReferral'',
    @TokenizeColumns=N''DiagnosisComboKey,FirstEncounterDateKey,FirstEncounterKey,HospitalChargeAmount,Patientkey,PrimaryDiagnosisKey,ReferralEpicId,ReferredToProviderSpecialty,SourceID'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_epic.FactVisit
-- Columns to tokenize: DepartmentEpicID,EncounterEpicCSN,EncounterKey,NewPatientStatus,PatientDurableKey,PatientKey,PrimaryCareProviderDurableKey,PrimaryMRN,Source_Id
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_epic_FactVisit';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_epic.FactVisit from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_epic'',
    @SourceTable=N''FactVisit'',
    @TargetSchema=N''B_epic'',
    @TargetTable=N''FactVisit'',
    @TokenizeColumns=N''DepartmentEpicID,EncounterEpicCSN,EncounterKey,NewPatientStatus,PatientDurableKey,PatientKey,PrimaryCareProviderDurableKey,PrimaryMRN,Source_Id'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_epic.FinDiv
-- Columns to tokenize: Findivid,SourceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_epic_FinDiv';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_epic.FinDiv from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_epic'',
    @SourceTable=N''FinDiv'',
    @TargetSchema=N''B_epic'',
    @TargetTable=N''FinDiv'',
    @TokenizeColumns=N''Findivid,SourceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_epic.FinSubdiv
-- Columns to tokenize: Findivid,Finsubdivid,SourceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_epic_FinSubdiv';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_epic.FinSubdiv from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_epic'',
    @SourceTable=N''FinSubdiv'',
    @TargetSchema=N''B_epic'',
    @TargetTable=N''FinSubdiv'',
    @TokenizeColumns=N''Findivid,Finsubdivid,SourceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_epic.Gender
-- Columns to tokenize: SourceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_epic_Gender';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_epic.Gender from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_epic'',
    @SourceTable=N''Gender'',
    @TargetSchema=N''B_epic'',
    @TargetTable=N''Gender'',
    @TokenizeColumns=N''SourceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_epic.ICDCode
-- Columns to tokenize: ICDType,SourceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_epic_ICDCode';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_epic.ICDCode from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_epic'',
    @SourceTable=N''ICDCode'',
    @TargetSchema=N''B_epic'',
    @TargetTable=N''ICDCode'',
    @TokenizeColumns=N''ICDType,SourceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_epic.InsuranceClass
-- Columns to tokenize: ClassName,SourceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_epic_InsuranceClass';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_epic.InsuranceClass from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_epic'',
    @SourceTable=N''InsuranceClass'',
    @TargetSchema=N''B_epic'',
    @TargetTable=N''InsuranceClass'',
    @TokenizeColumns=N''ClassName,SourceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_epic.LOINCCode
-- Columns to tokenize: SourceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_epic_LOINCCode';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_epic.LOINCCode from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_epic'',
    @SourceTable=N''LOINCCode'',
    @TargetSchema=N''B_epic'',
    @TargetTable=N''LOINCCode'',
    @TokenizeColumns=N''SourceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_epic.Language
-- Columns to tokenize: SourceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_epic_Language';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_epic.Language from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_epic'',
    @SourceTable=N''Language'',
    @TargetSchema=N''B_epic'',
    @TargetTable=N''Language'',
    @TokenizeColumns=N''SourceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_epic.NDCCode
-- Columns to tokenize: SourceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_epic_NDCCode';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_epic.NDCCode from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_epic'',
    @SourceTable=N''NDCCode'',
    @TargetSchema=N''B_epic'',
    @TargetTable=N''NDCCode'',
    @TokenizeColumns=N''SourceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_epic.Patient
-- Columns to tokenize: MRN,MRN Type,PatID,SourceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_epic_Patient';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_epic.Patient from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_epic'',
    @SourceTable=N''Patient'',
    @TargetSchema=N''B_epic'',
    @TargetTable=N''Patient'',
    @TokenizeColumns=N''MRN,MRN Type,PatID,SourceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_epic.PatientDim
-- Columns to tokenize: PatID,PatientKey,PrimaryCareProviderKey,PrimaryMrn,SourceID
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_epic_PatientDim';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_epic.PatientDim from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_epic'',
    @SourceTable=N''PatientDim'',
    @TargetSchema=N''B_epic'',
    @TargetTable=N''PatientDim'',
    @TokenizeColumns=N''PatID,PatientKey,PrimaryCareProviderKey,PrimaryMrn,SourceID'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_epic.Payor
-- Columns to tokenize: SourceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_epic_Payor';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_epic.Payor from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_epic'',
    @SourceTable=N''Payor'',
    @TargetSchema=N''B_epic'',
    @TargetTable=N''Payor'',
    @TokenizeColumns=N''SourceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_epic.ProviderDim
-- Columns to tokenize: ProviderEpicId,ProviderKey,SourceID
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_epic_ProviderDim';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_epic.ProviderDim from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_epic'',
    @SourceTable=N''ProviderDim'',
    @TargetSchema=N''B_epic'',
    @TargetTable=N''ProviderDim'',
    @TokenizeColumns=N''ProviderEpicId,ProviderKey,SourceID'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_epic.QualityOutcomeFact
-- Columns to tokenize: Encounterepiccsn,Encounterkey,Patientdurablekey,Providerdurablekey,Providername,Regulatoryentityid,SourceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_epic_QualityOutcomeFact';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_epic.QualityOutcomeFact from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_epic'',
    @SourceTable=N''QualityOutcomeFact'',
    @TargetSchema=N''B_epic'',
    @TargetTable=N''QualityOutcomeFact'',
    @TokenizeColumns=N''Encounterepiccsn,Encounterkey,Patientdurablekey,Providerdurablekey,Providername,Regulatoryentityid,SourceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_epic.Race
-- Columns to tokenize: SourceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_epic_Race';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_epic.Race from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_epic'',
    @SourceTable=N''Race'',
    @TargetSchema=N''B_epic'',
    @TargetTable=N''Race'',
    @TokenizeColumns=N''SourceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_epic.RxNormCode
-- Columns to tokenize: SourceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_epic_RxNormCode';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_epic.RxNormCode from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_epic'',
    @SourceTable=N''RxNormCode'',
    @TargetSchema=N''B_epic'',
    @TargetTable=N''RxNormCode'',
    @TokenizeColumns=N''SourceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_epic.SNOMEDCode
-- Columns to tokenize: SourceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_epic_SNOMEDCode';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_epic.SNOMEDCode from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_epic'',
    @SourceTable=N''SNOMEDCode'',
    @TargetSchema=N''B_epic'',
    @TargetTable=N''SNOMEDCode'',
    @TokenizeColumns=N''SourceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_epic.State
-- Columns to tokenize: SourceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_epic_State';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_epic.State from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_epic'',
    @SourceTable=N''State'',
    @TargetSchema=N''B_epic'',
    @TargetTable=N''State'',
    @TokenizeColumns=N''SourceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_epic.TeraAvailability
-- Columns to tokenize: Departmentid,Locationid,Providerid,Providername,SourceId,Unavailablersnname
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_epic_TeraAvailability';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_epic.TeraAvailability from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_epic'',
    @SourceTable=N''TeraAvailability'',
    @TargetSchema=N''B_epic'',
    @TargetTable=N''TeraAvailability'',
    @TokenizeColumns=N''Departmentid,Locationid,Providerid,Providername,SourceId,Unavailablersnname'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_epic.TeraFacility
-- Columns to tokenize: SourceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_epic_TeraFacility';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_epic.TeraFacility from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_epic'',
    @SourceTable=N''TeraFacility'',
    @TargetSchema=N''B_epic'',
    @TargetTable=N''TeraFacility'',
    @TokenizeColumns=N''SourceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_epic.UnitOfMeasure
-- Columns to tokenize: SourceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_epic_UnitOfMeasure';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_epic.UnitOfMeasure from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_epic'',
    @SourceTable=N''UnitOfMeasure'',
    @TargetSchema=N''B_epic'',
    @TargetTable=N''UnitOfMeasure'',
    @TokenizeColumns=N''SourceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_epic.VTeraAvailability
-- Columns to tokenize: Departmentid,Locationid,Providerid,Providername,SourceId,Unavailablereason
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_epic_VTeraAvailability';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_epic.VTeraAvailability from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_epic'',
    @SourceTable=N''VTeraAvailability'',
    @TargetSchema=N''B_epic'',
    @TargetTable=N''VTeraAvailability'',
    @TokenizeColumns=N''Departmentid,Locationid,Providerid,Providername,SourceId,Unavailablereason'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_epic.VTeraAvailability_backup
-- Columns to tokenize: Departmentid,Locationid,Providerid,Providername,SourceId,Unavailablereason
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_epic_VTeraAvailability_backup';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_epic.VTeraAvailability_backup from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_epic'',
    @SourceTable=N''VTeraAvailability_backup'',
    @TargetSchema=N''B_epic'',
    @TargetTable=N''VTeraAvailability_backup'',
    @TokenizeColumns=N''Departmentid,Locationid,Providerid,Providername,SourceId,Unavailablereason'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_epic.VTeraFacilityidCount
-- Columns to tokenize: Adstransactionsfacilityid,Adsvpatmasterfact2physloadfacilityid,Locationccn,Locationepicid,Regionepicid,Serviceareaepicid,SourceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_epic_VTeraFacilityidCount';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_epic.VTeraFacilityidCount from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_epic'',
    @SourceTable=N''VTeraFacilityidCount'',
    @TargetSchema=N''B_epic'',
    @TargetTable=N''VTeraFacilityidCount'',
    @TokenizeColumns=N''Adstransactionsfacilityid,Adsvpatmasterfact2physloadfacilityid,Locationccn,Locationepicid,Regionepicid,Serviceareaepicid,SourceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_epic.VTeraFacilityidCount_copy
-- Columns to tokenize: Adstransactionsfacilityid,Adsvpatmasterfact2physloadfacilityid,Locationccn,Locationepicid,Regionepicid,Serviceareaepicid,SourceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_epic_VTeraFacilityidCount_copy';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_epic.VTeraFacilityidCount_copy from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_epic'',
    @SourceTable=N''VTeraFacilityidCount_copy'',
    @TargetSchema=N''B_epic'',
    @TargetTable=N''VTeraFacilityidCount_copy'',
    @TokenizeColumns=N''Adstransactionsfacilityid,Adsvpatmasterfact2physloadfacilityid,Locationccn,Locationepicid,Regionepicid,Serviceareaepicid,SourceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_epic.ZcSaRptGrp10
-- Columns to tokenize: Internalid,SourceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_epic_ZcSaRptGrp10';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_epic.ZcSaRptGrp10 from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_epic'',
    @SourceTable=N''ZcSaRptGrp10'',
    @TargetSchema=N''B_epic'',
    @TargetTable=N''ZcSaRptGrp10'',
    @TokenizeColumns=N''Internalid,SourceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_filledposition.ProviderTalentRecruitmentData
-- Columns to tokenize: Candidatename,Candidatenpi,Candidatesign,Candidatesignyear,Providertype,SourceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_filledposition_ProviderTalentRecruitmentData';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_filledposition.ProviderTalentRecruitmentData from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_filledposition'',
    @SourceTable=N''ProviderTalentRecruitmentData'',
    @TargetSchema=N''B_filledposition'',
    @TargetTable=N''ProviderTalentRecruitmentData'',
    @TokenizeColumns=N''Candidatename,Candidatenpi,Candidatesign,Candidatesignyear,Providertype,SourceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_filledposition.ProviderTalentRecruitmentDataMountain
-- Columns to tokenize: Candidatename,Candidatenpi,Candidatesign,Candidatesignyear,Providertype,SourceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_filledposition_ProviderTalentRecruitmentDataMountain';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_filledposition.ProviderTalentRecruitmentDataMountain from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_filledposition'',
    @SourceTable=N''ProviderTalentRecruitmentDataMountain'',
    @TargetSchema=N''B_filledposition'',
    @TargetTable=N''ProviderTalentRecruitmentDataMountain'',
    @TokenizeColumns=N''Candidatename,Candidatenpi,Candidatesign,Candidatesignyear,Providertype,SourceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_five9.ACD_Report
-- Columns to tokenize: AgentEmail,AgentFirstName,AgentLastName,CallId,CallSurveyResult,Disposition,DispositionGroupA,DispositionGroupB,DispositionGroupC,DispositionPath,QueueCallbackProcessing,SourceId,Voicemails,VoicemailsDeclined,VoicemailsDeleted,VoicemailsHandled,VoicemailsReturnedCall,VoicemailsTransferred
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_five9_ACD_Report';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_five9.ACD_Report from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_five9'',
    @SourceTable=N''ACD_Report'',
    @TargetSchema=N''B_five9'',
    @TargetTable=N''ACD_Report'',
    @TokenizeColumns=N''AgentEmail,AgentFirstName,AgentLastName,CallId,CallSurveyResult,Disposition,DispositionGroupA,DispositionGroupB,DispositionGroupC,DispositionPath,QueueCallbackProcessing,SourceId,Voicemails,VoicemailsDeclined,VoicemailsDeleted,VoicemailsHandled,VoicemailsReturnedCall,VoicemailsTransferred'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_five9.ACD_Report_new
-- Columns to tokenize: AgentEmail,AgentFirstName,AgentLastName,CallId,CallSurveyResult,Disposition,DispositionGroupA,DispositionGroupB,DispositionGroupC,DispositionPath,QueueCallbackProcessing,SourceId,Voicemails,VoicemailsDeclined,VoicemailsDeleted,VoicemailsHandled,VoicemailsReturnedCall,VoicemailsTransferred
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_five9_ACD_Report_new';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_five9.ACD_Report_new from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_five9'',
    @SourceTable=N''ACD_Report_new'',
    @TargetSchema=N''B_five9'',
    @TargetTable=N''ACD_Report_new'',
    @TokenizeColumns=N''AgentEmail,AgentFirstName,AgentLastName,CallId,CallSurveyResult,Disposition,DispositionGroupA,DispositionGroupB,DispositionGroupC,DispositionPath,QueueCallbackProcessing,SourceId,Voicemails,VoicemailsDeclined,VoicemailsDeleted,VoicemailsHandled,VoicemailsReturnedCall,VoicemailsTransferred'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_five9.AgentState
-- Columns to tokenize: Full_Name,Media_Availability
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_five9_AgentState';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_five9.AgentState from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_five9'',
    @SourceTable=N''AgentState'',
    @TargetSchema=N''B_five9'',
    @TargetTable=N''AgentState'',
    @TokenizeColumns=N''Full_Name,Media_Availability'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_five9.AgentStatistics
-- Columns to tokenize: 02_Appointment__New_Patient,05_Message__Medication,07_Message__Result_Referral_Paperwork_etc,09_No_Call__Patient_Disconnect,Avg_Idle_Time,Avg_VM_Processing_Time,Full_Name,No_Disposition,Processed_Voicemails,Resource_Unavailable,Sent_To_Voicemail,Voicemail_Dump,Voicemail_Processed,Voicemail_Returned
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_five9_AgentStatistics';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_five9.AgentStatistics from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_five9'',
    @SourceTable=N''AgentStatistics'',
    @TargetSchema=N''B_five9'',
    @TargetTable=N''AgentStatistics'',
    @TokenizeColumns=N''02_Appointment__New_Patient,05_Message__Medication,07_Message__Result_Referral_Paperwork_etc,09_No_Call__Patient_Disconnect,Avg_Idle_Time,Avg_VM_Processing_Time,Full_Name,No_Disposition,Processed_Voicemails,Resource_Unavailable,Sent_To_Voicemail,Voicemail_Dump,Voicemail_Processed,Voicemail_Returned'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_five9.Agent_Report
-- Columns to tokenize: AgentEmail,AgentFirstName,AgentId,AgentLastName,AvailableForAll,AvailableForCalls,AvailableForVm,CallId,CallSurveyResult,Disposition,DispositionGroupA,DispositionGroupB,DispositionGroupC,DispositionPath,EnabledForVideo,MediaAvailability,OnVoicemailTime,PaidTime,QueueCallbackProcessing,SkillAvailability,SourceId,UnavailableForCalls,UnavailableForVm,UnpaidTime,VideoTime,VoicemailHandleTime,Voicemails,VoicemailsDeclined,VoicemailsDeleted,VoicemailsHandled,VoicemailsReturnedCall,VoicemailsTransferred
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_five9_Agent_Report';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_five9.Agent_Report from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_five9'',
    @SourceTable=N''Agent_Report'',
    @TargetSchema=N''B_five9'',
    @TargetTable=N''Agent_Report'',
    @TokenizeColumns=N''AgentEmail,AgentFirstName,AgentId,AgentLastName,AvailableForAll,AvailableForCalls,AvailableForVm,CallId,CallSurveyResult,Disposition,DispositionGroupA,DispositionGroupB,DispositionGroupC,DispositionPath,EnabledForVideo,MediaAvailability,OnVoicemailTime,PaidTime,QueueCallbackProcessing,SkillAvailability,SourceId,UnavailableForCalls,UnavailableForVm,UnpaidTime,VideoTime,VoicemailHandleTime,Voicemails,VoicemailsDeclined,VoicemailsDeleted,VoicemailsHandled,VoicemailsReturnedCall,VoicemailsTransferred'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_five9.Agent_Report_new
-- Columns to tokenize: AgentEmail,AgentFirstName,AgentId,AgentLastName,AvailableForAll,AvailableForCalls,AvailableForVm,CallId,CallSurveyResult,Disposition,DispositionGroupA,DispositionGroupB,DispositionGroupC,DispositionPath,EnabledForVideo,MediaAvailability,OnVoicemailTime,PaidTime,QueueCallbackProcessing,SkillAvailability,SourceId,UnavailableForCalls,UnavailableForVm,UnpaidTime,VideoTime,VoicemailHandleTime,Voicemails,VoicemailsDeclined,VoicemailsDeleted,VoicemailsHandled,VoicemailsReturnedCall,VoicemailsTransferred
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_five9_Agent_Report_new';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_five9.Agent_Report_new from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_five9'',
    @SourceTable=N''Agent_Report_new'',
    @TargetSchema=N''B_five9'',
    @TargetTable=N''Agent_Report_new'',
    @TokenizeColumns=N''AgentEmail,AgentFirstName,AgentId,AgentLastName,AvailableForAll,AvailableForCalls,AvailableForVm,CallId,CallSurveyResult,Disposition,DispositionGroupA,DispositionGroupB,DispositionGroupC,DispositionPath,EnabledForVideo,MediaAvailability,OnVoicemailTime,PaidTime,QueueCallbackProcessing,SkillAvailability,SourceId,UnavailableForCalls,UnavailableForVm,UnpaidTime,VideoTime,VoicemailHandleTime,Voicemails,VoicemailsDeclined,VoicemailsDeleted,VoicemailsHandled,VoicemailsReturnedCall,VoicemailsTransferred'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_five9.CalllogReport
-- Columns to tokenize: Agent.stationId,AgentEmail,AgentFirstName,AgentId,AgentLastName,Ardent.sourceid,Ardent.subjectid,CallId,CallSurveyResult,ContactId,DestAgentEmail,DestAgentFirstName,DestAgentLastName,DialResult,Disposition,DispositionGroupA,DispositionGroupB,DispositionGroupC,DispositionPath,Email,FirstName,LastName,ParentSessionId,QueueCallbackProcessing,SessionId,SourceId,Street,Studio.intentConfidence,Studio.intentConfidenceThreshold,Studio.patientAni,Studio.patientAuth,Studio.patientAuthReason,Studio.patientId,Studio.patientType,Studio.regionId,Studio.sourceid,Studio.subjectid,Studio.taskAccountId,Studio.taskId,Studio.taskUuid,Studio.transferDisposition,Studio.visitType,VideoTime,Voicemails,VoicemailsDeclined,VoicemailsDeleted,VoicemailsHandleTime,VoicemailsHandled,VoicemailsReturnedCall,VoicemailsTransferred,WorksheetId,Zip
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_five9_CalllogReport';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_five9.CalllogReport from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_five9'',
    @SourceTable=N''CalllogReport'',
    @TargetSchema=N''B_five9'',
    @TargetTable=N''CalllogReport'',
    @TokenizeColumns=N''Agent.stationId,AgentEmail,AgentFirstName,AgentId,AgentLastName,Ardent.sourceid,Ardent.subjectid,CallId,CallSurveyResult,ContactId,DestAgentEmail,DestAgentFirstName,DestAgentLastName,DialResult,Disposition,DispositionGroupA,DispositionGroupB,DispositionGroupC,DispositionPath,Email,FirstName,LastName,ParentSessionId,QueueCallbackProcessing,SessionId,SourceId,Street,Studio.intentConfidence,Studio.intentConfidenceThreshold,Studio.patientAni,Studio.patientAuth,Studio.patientAuthReason,Studio.patientId,Studio.patientType,Studio.regionId,Studio.sourceid,Studio.subjectid,Studio.taskAccountId,Studio.taskId,Studio.taskUuid,Studio.transferDisposition,Studio.visitType,VideoTime,Voicemails,VoicemailsDeclined,VoicemailsDeleted,VoicemailsHandleTime,VoicemailsHandled,VoicemailsReturnedCall,VoicemailsTransferred,WorksheetId,Zip'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_five9.Callog_Report_new
-- Columns to tokenize: Agent.stationId,AgentEmail,AgentFirstName,AgentId,AgentLastName,Ardent.sourceid,Ardent.subjectid,CallId,CallSurveyResult,ContactId,DestAgentEmail,DestAgentFirstName,DestAgentLastName,DialResult,Disposition,DispositionGroupA,DispositionGroupB,DispositionGroupC,DispositionPath,Email,FirstName,LastName,ParentSessionId,QueueCallbackProcessing,SessionId,SourceId,Street,Studio.intentConfidence,Studio.intentConfidenceThreshold,Studio.patientAni,Studio.patientAuth,Studio.patientAuthReason,Studio.patientId,Studio.patientType,Studio.regionId,Studio.sourceid,Studio.subjectid,Studio.taskAccountId,Studio.taskId,Studio.taskUuid,Studio.transferDisposition,Studio.visitType,VideoTime,Voicemails,VoicemailsDeclined,VoicemailsDeleted,VoicemailsHandleTime,VoicemailsHandled,VoicemailsReturnedCall,VoicemailsTransferred,WorksheetId,Zip
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_five9_Callog_Report_new';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_five9.Callog_Report_new from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_five9'',
    @SourceTable=N''Callog_Report_new'',
    @TargetSchema=N''B_five9'',
    @TargetTable=N''Callog_Report_new'',
    @TokenizeColumns=N''Agent.stationId,AgentEmail,AgentFirstName,AgentId,AgentLastName,Ardent.sourceid,Ardent.subjectid,CallId,CallSurveyResult,ContactId,DestAgentEmail,DestAgentFirstName,DestAgentLastName,DialResult,Disposition,DispositionGroupA,DispositionGroupB,DispositionGroupC,DispositionPath,Email,FirstName,LastName,ParentSessionId,QueueCallbackProcessing,SessionId,SourceId,Street,Studio.intentConfidence,Studio.intentConfidenceThreshold,Studio.patientAni,Studio.patientAuth,Studio.patientAuthReason,Studio.patientId,Studio.patientType,Studio.regionId,Studio.sourceid,Studio.subjectid,Studio.taskAccountId,Studio.taskId,Studio.taskUuid,Studio.transferDisposition,Studio.visitType,VideoTime,Voicemails,VoicemailsDeclined,VoicemailsDeleted,VoicemailsHandleTime,VoicemailsHandled,VoicemailsReturnedCall,VoicemailsTransferred,WorksheetId,Zip'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_five9.InboundCamoaignStatistics
-- Columns to tokenize: 02_Appointment__New_Patient,05_Message__Medication,07_Message__Result_Referral_Paperwork_etc,09_No_Call__Patient_Disconnect,No_Disposition,Resource_Unavailable,Sent_To_Voicemail,Voicemail_Dump,Voicemail_Processed,Voicemail_Returned
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_five9_InboundCamoaignStatistics';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_five9.InboundCamoaignStatistics from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_five9'',
    @SourceTable=N''InboundCamoaignStatistics'',
    @TargetSchema=N''B_five9'',
    @TargetTable=N''InboundCamoaignStatistics'',
    @TokenizeColumns=N''02_Appointment__New_Patient,05_Message__Medication,07_Message__Result_Referral_Paperwork_etc,09_No_Call__Patient_Disconnect,No_Disposition,Resource_Unavailable,Sent_To_Voicemail,Voicemail_Dump,Voicemail_Processed,Voicemail_Returned'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_five9.OutboundCampaignStatistics
-- Columns to tokenize: 02_Appointment__New_Patient,05_Message__Medication,07_Message__Result_Referral_Paperwork_etc,09_No_Call__Patient_Disconnect,No_Disposition,Resource_Unavailable,Sent_To_Voicemail,Voicemail_Dump,Voicemail_Processed,Voicemail_Returned
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_five9_OutboundCampaignStatistics';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_five9.OutboundCampaignStatistics from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_five9'',
    @SourceTable=N''OutboundCampaignStatistics'',
    @TargetSchema=N''B_five9'',
    @TargetTable=N''OutboundCampaignStatistics'',
    @TokenizeColumns=N''02_Appointment__New_Patient,05_Message__Medication,07_Message__Result_Referral_Paperwork_etc,09_No_Call__Patient_Disconnect,No_Disposition,Resource_Unavailable,Sent_To_Voicemail,Voicemail_Dump,Voicemail_Processed,Voicemail_Returned'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_iam.srcAD
-- Columns to tokenize: SourceId,employeeid,givenname,msExchHideFromAddressLists,surname
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_iam_srcAD';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_iam.srcAD from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_iam'',
    @SourceTable=N''srcAD'',
    @TargetSchema=N''B_iam'',
    @TargetTable=N''srcAD'',
    @TokenizeColumns=N''SourceId,employeeid,givenname,msExchHideFromAddressLists,surname'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_iam.srcADgroups
-- Columns to tokenize: ObjectGUID,ProtectedFromAccidentalDeletion,SIDHistory,SourceId,managedObjects,member,objectSid
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_iam_srcADgroups';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_iam.srcADgroups from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_iam'',
    @SourceTable=N''srcADgroups'',
    @TargetSchema=N''B_iam'',
    @TargetTable=N''srcADgroups'',
    @TokenizeColumns=N''ObjectGUID,ProtectedFromAccidentalDeletion,SIDHistory,SourceId,managedObjects,member,objectSid'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_iam.srcAya
-- Columns to tokenize: BadgeID,DOB,Email,Employee ID,FirstName,Home Address,LastName,LexisNexisID,Manager_Email,Manager_EmpID,MiddleInt,Phone,Process_Level,SSN,SourceId,Zip
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_iam_srcAya';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_iam.srcAya from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_iam'',
    @SourceTable=N''srcAya'',
    @TargetSchema=N''B_iam'',
    @TargetTable=N''srcAya'',
    @TokenizeColumns=N''BadgeID,DOB,Email,Employee ID,FirstName,Home Address,LastName,LexisNexisID,Manager_Email,Manager_EmpID,MiddleInt,Phone,Process_Level,SSN,SourceId,Zip'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_iam.srcEnsemble
-- Columns to tokenize: Cost_Center_ID,Employee_ID,Home_Address1,Home_Address2,Last4SSN,Legal_Name-Middle,LexisNexisID,Manager-Level_01_EEID,Manager-Level_01_Email,Preferred_Name-Middle,SourceId,Work_Address1,Work_Address2,Work_Email
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_iam_srcEnsemble';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_iam.srcEnsemble from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_iam'',
    @SourceTable=N''srcEnsemble'',
    @TargetSchema=N''B_iam'',
    @TargetTable=N''srcEnsemble'',
    @TokenizeColumns=N''Cost_Center_ID,Employee_ID,Home_Address1,Home_Address2,Last4SSN,Legal_Name-Middle,LexisNexisID,Manager-Level_01_EEID,Manager-Level_01_Email,Preferred_Name-Middle,SourceId,Work_Address1,Work_Address2,Work_Email'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_iam.srcEpicAccounts
-- Columns to tokenize: Available Linkable Templates 1110,E0A Unique ID 48,Epic ID  1,SER Linked to Provider 17500,SourceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_iam_srcEpicAccounts';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_iam.srcEpicAccounts from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_iam'',
    @SourceTable=N''srcEpicAccounts'',
    @TargetSchema=N''B_iam'',
    @TargetTable=N''srcEpicAccounts'',
    @TokenizeColumns=N''Available Linkable Templates 1110,E0A Unique ID 48,Epic ID  1,SER Linked to Provider 17500,SourceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_iam.srcLawdataKronos
-- Columns to tokenize: LEXID,MIDDLE_INIT,SourceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_iam_srcLawdataKronos';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_iam.srcLawdataKronos from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_iam'',
    @SourceTable=N''srcLawdataKronos'',
    @TargetSchema=N''B_iam'',
    @TargetTable=N''srcLawdataKronos'',
    @TokenizeColumns=N''LEXID,MIDDLE_INIT,SourceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_iam.srcLawson
-- Columns to tokenize: DOB,EMAIL_ADDRESS,EMP_ID,FULL_NAME,HOME_ZIP,MANAGER_EID,MANAGER_EMAIL,MIDDLE_INIT,PREVIOUS_EID,PROCESS_LEVEL,SourceId,ZIP
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_iam_srcLawson';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_iam.srcLawson from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_iam'',
    @SourceTable=N''srcLawson'',
    @TargetSchema=N''B_iam'',
    @TargetTable=N''srcLawson'',
    @TokenizeColumns=N''DOB,EMAIL_ADDRESS,EMP_ID,FULL_NAME,HOME_ZIP,MANAGER_EID,MANAGER_EMAIL,MIDDLE_INIT,PREVIOUS_EID,PROCESS_LEVEL,SourceId,ZIP'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_iam.srcLawsonPositions
-- Columns to tokenize: PROCESS_LEVEL,PROCESS_LEVEL_DESCRIPTION,ProcessLevel Department,SourceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_iam_srcLawsonPositions';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_iam.srcLawsonPositions from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_iam'',
    @SourceTable=N''srcLawsonPositions'',
    @TargetSchema=N''B_iam'',
    @TargetTable=N''srcLawsonPositions'',
    @TokenizeColumns=N''PROCESS_LEVEL,PROCESS_LEVEL_DESCRIPTION,ProcessLevel Department,SourceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_iam.srcLexusnexus
-- Columns to tokenize: EMP_ID,LexisNexisID,SourceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_iam_srcLexusnexus';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_iam.srcLexusnexus from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_iam'',
    @SourceTable=N''srcLexusnexus'',
    @TargetSchema=N''B_iam'',
    @TargetTable=N''srcLexusnexus'',
    @TokenizeColumns=N''EMP_ID,LexisNexisID,SourceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_iam.srcManagers
-- Columns to tokenize: SourceId,Work_Email
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_iam_srcManagers';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_iam.srcManagers from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_iam'',
    @SourceTable=N''srcManagers'',
    @TargetSchema=N''B_iam'',
    @TargetTable=N''srcManagers'',
    @TokenizeColumns=N''SourceId,Work_Email'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_iam.srcNorthcampus
-- Columns to tokenize: Dob,Email,EmpID,FirstName,HomeAddress,LastName,LexisNexisID,Manager_Email,Manager_EmpID,Manager_Phone,MiddleInt,Phone,SSN,SourceId,ZIp
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_iam_srcNorthcampus';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_iam.srcNorthcampus from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_iam'',
    @SourceTable=N''srcNorthcampus'',
    @TargetSchema=N''B_iam'',
    @TargetTable=N''srcNorthcampus'',
    @TokenizeColumns=N''Dob,Email,EmpID,FirstName,HomeAddress,LastName,LexisNexisID,Manager_Email,Manager_EmpID,Manager_Phone,MiddleInt,Phone,SSN,SourceId,ZIp'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_iam.srcSodexo
-- Columns to tokenize: EMPL_EMAIL_ADDR,EMPL_ID,EMPL_MID_NM,EMPL_SSN,EMPL_ZIP_CD,LexisNexisID,MGR_EMAIL_ADDR,MGR_ID,SourceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_iam_srcSodexo';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_iam.srcSodexo from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_iam'',
    @SourceTable=N''srcSodexo'',
    @TargetSchema=N''B_iam'',
    @TargetTable=N''srcSodexo'',
    @TokenizeColumns=N''EMPL_EMAIL_ADDR,EMPL_ID,EMPL_MID_NM,EMPL_SSN,EMPL_ZIP_CD,LexisNexisID,MGR_EMAIL_ADDR,MGR_ID,SourceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_iam.srcSymplr
-- Columns to tokenize: Cell_Phone,Employee_ID,Legal_Name_Middle,LexisNexisID,Medicaid_Number,Medicare_Number,Primary_Practice_AddressLine1,Primary_Practice_AddressLine2,Primary_Practice_Email,Primary_Practice_Phone,Primary_Practice_ZipCode,Provider_K,SSN,SourceId,State_License_Number
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_iam_srcSymplr';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_iam.srcSymplr from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_iam'',
    @SourceTable=N''srcSymplr'',
    @TargetSchema=N''B_iam'',
    @TargetTable=N''srcSymplr'',
    @TokenizeColumns=N''Cell_Phone,Employee_ID,Legal_Name_Middle,LexisNexisID,Medicaid_Number,Medicare_Number,Primary_Practice_AddressLine1,Primary_Practice_AddressLine2,Primary_Practice_Email,Primary_Practice_Phone,Primary_Practice_ZipCode,Provider_K,SSN,SourceId,State_License_Number'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_icims.Icims
-- Columns to tokenize: # Currently in Bin Dispositioned Candidates,# Ever in Bin Dispositioned Candidates,Department   External ID,Department   Process Level,Hiring Manager   Primary Email Address,Laborlytics Approval ID,Preboarder   Primary Email,Recruiter   External ID,Recruiter   Primary Email Address,Relocation Provided,Requisition ID,Secondary Hiring Manager   Primary Email,Secondary Recruiter   Primary Email,Total # of Candidates,Total # of Candidates_1
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_icims_Icims';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_icims.Icims from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_icims'',
    @SourceTable=N''Icims'',
    @TargetSchema=N''B_icims'',
    @TargetTable=N''Icims'',
    @TokenizeColumns=N''# Currently in Bin Dispositioned Candidates,# Ever in Bin Dispositioned Candidates,Department   External ID,Department   Process Level,Hiring Manager   Primary Email Address,Laborlytics Approval ID,Preboarder   Primary Email,Recruiter   External ID,Recruiter   Primary Email Address,Relocation Provided,Requisition ID,Secondary Hiring Manager   Primary Email,Secondary Recruiter   Primary Email,Total # of Candidates,Total # of Candidates_1'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_improvado.callrail_calls
-- Columns to tokenize: account_id,agent_email,business_phone_number,call_id,company_id,customer_phone_number,formatted_business_phone_number,formatted_customer_name_or_phone_number,formatted_customer_phone_number,formatted_tracking_phone_number,gclid,good_lead_call_id,tracker_id,tracking_phone_number,voicemail
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_improvado_callrail_calls';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_improvado.callrail_calls from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_improvado'',
    @SourceTable=N''callrail_calls'',
    @TargetSchema=N''B_improvado'',
    @TargetTable=N''callrail_calls'',
    @TokenizeColumns=N''account_id,agent_email,business_phone_number,call_id,company_id,customer_phone_number,formatted_business_phone_number,formatted_customer_name_or_phone_number,formatted_customer_phone_number,formatted_tracking_phone_number,gclid,good_lead_call_id,tracker_id,tracking_phone_number,voicemail'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_improvado.cross_channel_model_ai
-- Columns to tokenize: ad_id,adset_id,advertiser_id,campaign_id,creative_id,placement_id,video_100_quartile_views,video_25_quartile_views,video_50_quartile_views,video_75_quartile_views,video_starts,video_views
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_improvado_cross_channel_model_ai';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_improvado.cross_channel_model_ai from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_improvado'',
    @SourceTable=N''cross_channel_model_ai'',
    @TargetSchema=N''B_improvado'',
    @TargetTable=N''cross_channel_model_ai'',
    @TokenizeColumns=N''ad_id,adset_id,advertiser_id,campaign_id,creative_id,placement_id,video_100_quartile_views,video_25_quartile_views,video_50_quartile_views,video_75_quartile_views,video_starts,video_views'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_improvado.data_dictionary
-- Columns to tokenize: agency_id,agency_uuid,customers_data_dictionary_id,datatable_id,dsas_datasource_id,dsas_report_type_id,dts_workspace_id,extract_template_id,field_id
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_improvado_data_dictionary';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_improvado.data_dictionary from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_improvado'',
    @SourceTable=N''data_dictionary'',
    @TargetSchema=N''B_improvado'',
    @TargetTable=N''data_dictionary'',
    @TokenizeColumns=N''agency_id,agency_uuid,customers_data_dictionary_id,datatable_id,dsas_datasource_id,dsas_report_type_id,dts_workspace_id,extract_template_id,field_id'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_improvado.datasource_accounts
-- Columns to tokenize: agency_id,agency_uuid,datasource_account_id,datasource_connection_id,datasource_connection_invalidated_at,datasource_connection_uid,datasource_remote_account_id,rtbmedia_datasource_connection_id,workspace_id
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_improvado_datasource_accounts';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_improvado.datasource_accounts from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_improvado'',
    @SourceTable=N''datasource_accounts'',
    @TargetSchema=N''B_improvado'',
    @TargetTable=N''datasource_accounts'',
    @TokenizeColumns=N''agency_id,agency_uuid,datasource_account_id,datasource_connection_id,datasource_connection_invalidated_at,datasource_connection_uid,datasource_remote_account_id,rtbmedia_datasource_connection_id,workspace_id'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_improvado.dim_ai_notebooks_meta
-- Columns to tokenize: agency_id,cell_id,notebook_id,user_email,workspace_id
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_improvado_dim_ai_notebooks_meta';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_improvado.dim_ai_notebooks_meta from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_improvado'',
    @SourceTable=N''dim_ai_notebooks_meta'',
    @TargetSchema=N''B_improvado'',
    @TargetTable=N''dim_ai_notebooks_meta'',
    @TokenizeColumns=N''agency_id,cell_id,notebook_id,user_email,workspace_id'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_improvado.extract_orders
-- Columns to tokenize: account_id,agency_id,datasource_account_id,datasource_connection_uid,datatable_id,dts_workspace_id,extract_params_id,extract_template_id,order_id,workspace_id
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_improvado_extract_orders';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_improvado.extract_orders from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_improvado'',
    @SourceTable=N''extract_orders'',
    @TargetSchema=N''B_improvado'',
    @TargetTable=N''extract_orders'',
    @TokenizeColumns=N''account_id,agency_id,datasource_account_id,datasource_connection_uid,datatable_id,dts_workspace_id,extract_params_id,extract_template_id,order_id,workspace_id'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_improvado.facebook_ads_ads_creative
-- Columns to tokenize: account_id,ad_id,adset_id,campaign_id,caption,catalog_mobile_add_to_cart,catalog_mobile_add_to_cart_value,catalog_mobile_content_view,catalog_mobile_content_view_value,catalog_mobile_purchase,catalog_mobile_purchase_value,creative_id,creative_instagram_actor_id,creative_page_id,effective_instagram_media_id,effective_object_story_id,fb_mobile_add_payment_info,fb_mobile_complete_registration,fb_mobile_content_view,fb_mobile_purchase,instagram_user_id,lead_gen_form_id,mobile_app_install,mobile_click_through,mobile_view_through,object_story_id,schedule_mobile_app,source_instagram_media_id,start_trial_mobile_app,video_30_sec_watched_actions,video_avg_time_watched_actions,video_creative_destination_url,video_p100_watched_actions,video_p25_watched_actions,video_p50_watched_actions,video_p75_watched_actions,video_p95_watched_actions,video_play_actions_view_value,video_play_actions_view_value_7d_click,video_view_3s,video_view_3s_7d_click
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_improvado_facebook_ads_ads_creative';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_improvado.facebook_ads_ads_creative from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_improvado'',
    @SourceTable=N''facebook_ads_ads_creative'',
    @TargetSchema=N''B_improvado'',
    @TargetTable=N''facebook_ads_ads_creative'',
    @TokenizeColumns=N''account_id,ad_id,adset_id,campaign_id,caption,catalog_mobile_add_to_cart,catalog_mobile_add_to_cart_value,catalog_mobile_content_view,catalog_mobile_content_view_value,catalog_mobile_purchase,catalog_mobile_purchase_value,creative_id,creative_instagram_actor_id,creative_page_id,effective_instagram_media_id,effective_object_story_id,fb_mobile_add_payment_info,fb_mobile_complete_registration,fb_mobile_content_view,fb_mobile_purchase,instagram_user_id,lead_gen_form_id,mobile_app_install,mobile_click_through,mobile_view_through,object_story_id,schedule_mobile_app,source_instagram_media_id,start_trial_mobile_app,video_30_sec_watched_actions,video_avg_time_watched_actions,video_creative_destination_url,video_p100_watched_actions,video_p25_watched_actions,video_p50_watched_actions,video_p75_watched_actions,video_p95_watched_actions,video_play_actions_view_value,video_play_actions_view_value_7d_click,video_view_3s,video_view_3s_7d_click'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_improvado.facebook_pages_page
-- Columns to tokenize: account_id,page_consumptions_by_video_play,page_consumptions_by_video_play_unique,page_fan_adds_by_paid_non_paid_unique_paid,page_fan_adds_by_paid_non_paid_unique_unpaid,page_id,page_impressions_paid,page_impressions_paid_unique,page_negative_feedback_by_hide_all_clicks,page_negative_feedback_by_hide_all_clicks_unique,page_negative_feedback_by_hide_clicks,page_negative_feedback_by_hide_clicks_unique,page_video_views_organic,page_video_views_paid,page_video_views_unique
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_improvado_facebook_pages_page';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_improvado.facebook_pages_page from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_improvado'',
    @SourceTable=N''facebook_pages_page'',
    @TargetSchema=N''B_improvado'',
    @TargetTable=N''facebook_pages_page'',
    @TokenizeColumns=N''account_id,page_consumptions_by_video_play,page_consumptions_by_video_play_unique,page_fan_adds_by_paid_non_paid_unique_paid,page_fan_adds_by_paid_non_paid_unique_unpaid,page_id,page_impressions_paid,page_impressions_paid_unique,page_negative_feedback_by_hide_all_clicks,page_negative_feedback_by_hide_all_clicks_unique,page_negative_feedback_by_hide_clicks,page_negative_feedback_by_hide_clicks_unique,page_video_views_organic,page_video_views_paid,page_video_views_unique'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_improvado.google_ads_ads
-- Columns to tokenize: account_id,ad_group_ad_label_ids,ad_group_ad_labels,ad_group_id,ad_group_labels,ad_id,ad_mobile_final_url,campaign_id,campaign_label_ids,campaign_label_names,customer_id,image_ad_pixel_width,responsive_display_ad_marketing_image_id,responsive_display_ad_square_logo_image_id,video_quartile_100,video_quartile_25,video_quartile_50,video_quartile_75,video_views
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_improvado_google_ads_ads';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_improvado.google_ads_ads from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_improvado'',
    @SourceTable=N''google_ads_ads'',
    @TargetSchema=N''B_improvado'',
    @TargetTable=N''google_ads_ads'',
    @TokenizeColumns=N''account_id,ad_group_ad_label_ids,ad_group_ad_labels,ad_group_id,ad_group_labels,ad_id,ad_mobile_final_url,campaign_id,campaign_label_ids,campaign_label_names,customer_id,image_ad_pixel_width,responsive_display_ad_marketing_image_id,responsive_display_ad_square_logo_image_id,video_quartile_100,video_quartile_25,video_quartile_50,video_quartile_75,video_views'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_improvado.google_ads_campaign
-- Columns to tokenize: account_id,bid_strategy_id,bid_strategy_name,bid_strategy_type,campaign_id,campaign_label_ids,campaign_labels,client_manager_id,customer_id,video_quartile_p100,video_quartile_p25,video_quartile_p50,video_quartile_p75,video_views
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_improvado_google_ads_campaign';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_improvado.google_ads_campaign from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_improvado'',
    @SourceTable=N''google_ads_campaign'',
    @TargetSchema=N''B_improvado'',
    @TargetTable=N''google_ads_campaign'',
    @TokenizeColumns=N''account_id,bid_strategy_id,bid_strategy_name,bid_strategy_type,campaign_id,campaign_label_ids,campaign_labels,client_manager_id,customer_id,video_quartile_p100,video_quartile_p25,video_quartile_p50,video_quartile_p75,video_views'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_improvado.google_business_profile_google_my_business_location_attributes
-- Columns to tokenize: account_id,location_id,phone_numbers,storefront_address
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_improvado_google_business_profile_google_my_business_location_attributes';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_improvado.google_business_profile_google_my_business_location_attributes from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_improvado'',
    @SourceTable=N''google_business_profile_google_my_business_location_attributes'',
    @TargetSchema=N''B_improvado'',
    @TargetTable=N''google_business_profile_google_my_business_location_attributes'',
    @TokenizeColumns=N''account_id,location_id,phone_numbers,storefront_address'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_improvado.google_business_profile_google_my_business_location_insights
-- Columns to tokenize: account_id,address_line,business_impressions_mobile_maps,business_impressions_mobile_search,labels,location_and_address,location_id
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_improvado_google_business_profile_google_my_business_location_insights';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_improvado.google_business_profile_google_my_business_location_insights from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_improvado'',
    @SourceTable=N''google_business_profile_google_my_business_location_insights'',
    @TargetSchema=N''B_improvado'',
    @TargetTable=N''google_business_profile_google_my_business_location_insights'',
    @TokenizeColumns=N''account_id,address_line,business_impressions_mobile_maps,business_impressions_mobile_search,labels,location_and_address,location_id'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_improvado.google_business_profile_google_my_business_location_reviews
-- Columns to tokenize: account_id,location_id
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_improvado_google_business_profile_google_my_business_location_reviews';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_improvado.google_business_profile_google_my_business_location_reviews from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_improvado'',
    @SourceTable=N''google_business_profile_google_my_business_location_reviews'',
    @TargetSchema=N''B_improvado'',
    @TargetTable=N''google_business_profile_google_my_business_location_reviews'',
    @TokenizeColumns=N''account_id,location_id'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_improvado.google_business_profile_google_my_business_location_reviews_incremental
-- Columns to tokenize: account_id,location_id
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_improvado_google_business_profile_google_my_business_location_reviews_incremental';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_improvado.google_business_profile_google_my_business_location_reviews_incremental from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_improvado'',
    @SourceTable=N''google_business_profile_google_my_business_location_reviews_incremental'',
    @TargetSchema=N''B_improvado'',
    @TargetTable=N''google_business_profile_google_my_business_location_reviews_incremental'',
    @TokenizeColumns=N''account_id,location_id'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_improvado.google_business_profile_google_my_business_phone_calls_daily
-- Columns to tokenize: account_id,location_id
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_improvado_google_business_profile_google_my_business_phone_calls_daily';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_improvado.google_business_profile_google_my_business_phone_calls_daily from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_improvado'',
    @SourceTable=N''google_business_profile_google_my_business_phone_calls_daily'',
    @TargetSchema=N''B_improvado'',
    @TargetTable=N''google_business_profile_google_my_business_phone_calls_daily'',
    @TokenizeColumns=N''account_id,location_id'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_improvado.google_business_profile_google_my_business_review_entity
-- Columns to tokenize: account_id,location_id,review_id
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_improvado_google_business_profile_google_my_business_review_entity';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_improvado.google_business_profile_google_my_business_review_entity from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_improvado'',
    @SourceTable=N''google_business_profile_google_my_business_review_entity'',
    @TargetSchema=N''B_improvado'',
    @TargetTable=N''google_business_profile_google_my_business_review_entity'',
    @TokenizeColumns=N''account_id,location_id,review_id'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_improvado.instagram_organic_page_insights
-- Columns to tokenize: account_id,email_contacts,phone_call_clicks
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_improvado_instagram_organic_page_insights';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_improvado.instagram_organic_page_insights from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_improvado'',
    @SourceTable=N''instagram_organic_page_insights'',
    @TargetSchema=N''B_improvado'',
    @TargetTable=N''instagram_organic_page_insights'',
    @TokenizeColumns=N''account_id,email_contacts,phone_call_clicks'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_improvado.linkedin_organic_page_statistics
-- Columns to tokenize: account_id,all_mobile_page_views,all_mobile_page_views_unique,mobile_about_page_views,mobile_about_page_views_unique,mobile_careers_page_employees_clicks,mobile_careers_page_jobs_promo_clicks,mobile_careers_page_promo_links_clicks,mobile_careers_page_views,mobile_careers_page_views_unique,mobile_insights_page_views,mobile_insights_page_views_unique,mobile_jobs_page_views,mobile_jobs_page_views_unique,mobile_life_at_page_views,mobile_life_at_page_views_unique,mobile_overview_page_views,mobile_overview_page_views_unique,mobile_people_page_views,mobile_people_page_views_unique
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_improvado_linkedin_organic_page_statistics';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_improvado.linkedin_organic_page_statistics from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_improvado'',
    @SourceTable=N''linkedin_organic_page_statistics'',
    @TargetSchema=N''B_improvado'',
    @TargetTable=N''linkedin_organic_page_statistics'',
    @TokenizeColumns=N''account_id,all_mobile_page_views,all_mobile_page_views_unique,mobile_about_page_views,mobile_about_page_views_unique,mobile_careers_page_employees_clicks,mobile_careers_page_jobs_promo_clicks,mobile_careers_page_promo_links_clicks,mobile_careers_page_views,mobile_careers_page_views_unique,mobile_insights_page_views,mobile_insights_page_views_unique,mobile_jobs_page_views,mobile_jobs_page_views_unique,mobile_life_at_page_views,mobile_life_at_page_views_unique,mobile_overview_page_views,mobile_overview_page_views_unique,mobile_people_page_views,mobile_people_page_views_unique'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_improvado.load_orders
-- Columns to tokenize: agency_id,customer_load_order_id,datatable_id,dts_destination_id,dts_workspace_id,load_params_id,order_id,workspace_id
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_improvado_load_orders';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_improvado.load_orders from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_improvado'',
    @SourceTable=N''load_orders'',
    @TargetSchema=N''B_improvado'',
    @TargetTable=N''load_orders'',
    @TokenizeColumns=N''agency_id,customer_load_order_id,datatable_id,dts_destination_id,dts_workspace_id,load_params_id,order_id,workspace_id'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_improvado.matomo_general
-- Columns to tokenize: account_id,actions_per_visit,actions_per_visit_new,actions_per_visit_returning,avg_time_dom_processing,dom_processing_hits,dom_processing_time,new_visit_conversions,new_visits,returning_visit_conversions,returning_visits,revenue_new_visit,revenue_returning_visit,sum_visit_length,unique_new_visitors,unique_returning_visitors,unique_visitors,visitors_from_campaigns,visitors_from_direct_entry,visitors_from_search_engines,visitors_from_social_networks,visitors_from_websites,visits,visits_converted,visits_converted_new_visit,visits_converted_returning_visit
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_improvado_matomo_general';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_improvado.matomo_general from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_improvado'',
    @SourceTable=N''matomo_general'',
    @TargetSchema=N''B_improvado'',
    @TargetTable=N''matomo_general'',
    @TokenizeColumns=N''account_id,actions_per_visit,actions_per_visit_new,actions_per_visit_returning,avg_time_dom_processing,dom_processing_hits,dom_processing_time,new_visit_conversions,new_visits,returning_visit_conversions,returning_visits,revenue_new_visit,revenue_returning_visit,sum_visit_length,unique_new_visitors,unique_returning_visitors,unique_visitors,visitors_from_campaigns,visitors_from_direct_entry,visitors_from_search_engines,visitors_from_social_networks,visitors_from_websites,visits,visits_converted,visits_converted_new_visit,visits_converted_returning_visit'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_improvado.src_improvado_currency_exchange_rates
-- Columns to tokenize: currency_exchange_daily_grain_id
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_improvado_src_improvado_currency_exchange_rates';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_improvado.src_improvado_currency_exchange_rates from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_improvado'',
    @SourceTable=N''src_improvado_currency_exchange_rates'',
    @TargetSchema=N''B_improvado'',
    @TargetTable=N''src_improvado_currency_exchange_rates'',
    @TokenizeColumns=N''currency_exchange_daily_grain_id'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_improvado.src_improvado_dataflow_run_events
-- Columns to tokenize: agency_id,agency_uuid,dataflow_id,dataflow_run_id,datasource_connection_id,datasource_connection_uid,datasource_remote_account_id,dts_agency_whitelabel_host,dts_datatable_id,order_id,workspace_id
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_improvado_src_improvado_dataflow_run_events';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_improvado.src_improvado_dataflow_run_events from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_improvado'',
    @SourceTable=N''src_improvado_dataflow_run_events'',
    @TargetSchema=N''B_improvado'',
    @TargetTable=N''src_improvado_dataflow_run_events'',
    @TokenizeColumns=N''agency_id,agency_uuid,dataflow_id,dataflow_run_id,datasource_connection_id,datasource_connection_uid,datasource_remote_account_id,dts_agency_whitelabel_host,dts_datatable_id,order_id,workspace_id'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_improvado.src_improvado_order_runs_billing
-- Columns to tokenize: agency_id,agency_uuid,agreement_id,billing_grain_id,company_domain_id,datasource_account_id,datasource_remote_account_id,datatable_id,notification_email,order_id,order_run_processed_rows,whitelabel_host,whitelabel_id,whitelabel_name,whitelabel_title,workspace_id
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_improvado_src_improvado_order_runs_billing';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_improvado.src_improvado_order_runs_billing from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_improvado'',
    @SourceTable=N''src_improvado_order_runs_billing'',
    @TargetSchema=N''B_improvado'',
    @TargetTable=N''src_improvado_order_runs_billing'',
    @TokenizeColumns=N''agency_id,agency_uuid,agreement_id,billing_grain_id,company_domain_id,datasource_account_id,datasource_remote_account_id,datatable_id,notification_email,order_id,order_run_processed_rows,whitelabel_host,whitelabel_id,whitelabel_name,whitelabel_title,workspace_id'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_improvado.test
-- Columns to tokenize: account_id
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_improvado_test';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_improvado.test from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_improvado'',
    @SourceTable=N''test'',
    @TargetSchema=N''B_improvado'',
    @TargetTable=N''test'',
    @TokenizeColumns=N''account_id'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_improvado.unlock_daily_adstats
-- Columns to tokenize: __account_id,ad_group_id,creative_id,image_creative_image_width,platform_campaign_id,video_views
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_improvado_unlock_daily_adstats';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_improvado.unlock_daily_adstats from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_improvado'',
    @SourceTable=N''unlock_daily_adstats'',
    @TargetSchema=N''B_improvado'',
    @TargetTable=N''unlock_daily_adstats'',
    @TokenizeColumns=N''__account_id,ad_group_id,creative_id,image_creative_image_width,platform_campaign_id,video_views'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_improvado.unlock_daily_agerange
-- Columns to tokenize: __account_id,platform_campaign_id
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_improvado_unlock_daily_agerange';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_improvado.unlock_daily_agerange from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_improvado'',
    @SourceTable=N''unlock_daily_agerange'',
    @TargetSchema=N''B_improvado'',
    @TargetTable=N''unlock_daily_agerange'',
    @TokenizeColumns=N''__account_id,platform_campaign_id'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_improvado.unlock_daily_devicestats
-- Columns to tokenize: __account_id,ad_group_id,creative_id,platform_campaign_id
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_improvado_unlock_daily_devicestats';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_improvado.unlock_daily_devicestats from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_improvado'',
    @SourceTable=N''unlock_daily_devicestats'',
    @TargetSchema=N''B_improvado'',
    @TargetTable=N''unlock_daily_devicestats'',
    @TokenizeColumns=N''__account_id,ad_group_id,creative_id,platform_campaign_id'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_improvado.unlock_daily_engagementstats
-- Columns to tokenize: __account_id,adgroup_id,creative_id,platform_campaign_id
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_improvado_unlock_daily_engagementstats';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_improvado.unlock_daily_engagementstats from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_improvado'',
    @SourceTable=N''unlock_daily_engagementstats'',
    @TargetSchema=N''B_improvado'',
    @TargetTable=N''unlock_daily_engagementstats'',
    @TokenizeColumns=N''__account_id,adgroup_id,creative_id,platform_campaign_id'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_improvado.unlock_daily_genderstats
-- Columns to tokenize: __account_id,platform_campaign_id
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_improvado_unlock_daily_genderstats';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_improvado.unlock_daily_genderstats from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_improvado'',
    @SourceTable=N''unlock_daily_genderstats'',
    @TargetSchema=N''B_improvado'',
    @TargetTable=N''unlock_daily_genderstats'',
    @TokenizeColumns=N''__account_id,platform_campaign_id'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_improvado.unlock_daily_geostats
-- Columns to tokenize: __account_id,platform_campaign_id,video_views,zip
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_improvado_unlock_daily_geostats';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_improvado.unlock_daily_geostats from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_improvado'',
    @SourceTable=N''unlock_daily_geostats'',
    @TargetSchema=N''B_improvado'',
    @TargetTable=N''unlock_daily_geostats'',
    @TokenizeColumns=N''__account_id,platform_campaign_id,video_views,zip'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_improvado.unlock_daily_keywordstats
-- Columns to tokenize: __account_id,ad_group_id,platform_campaign_id
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_improvado_unlock_daily_keywordstats';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_improvado.unlock_daily_keywordstats from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_improvado'',
    @SourceTable=N''unlock_daily_keywordstats'',
    @TargetSchema=N''B_improvado'',
    @TargetTable=N''unlock_daily_keywordstats'',
    @TokenizeColumns=N''__account_id,ad_group_id,platform_campaign_id'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_improvado.unlock_monthly_campaigns
-- Columns to tokenize: __account_id,platform_campaign_id
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_improvado_unlock_monthly_campaigns';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_improvado.unlock_monthly_campaigns from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_improvado'',
    @SourceTable=N''unlock_monthly_campaigns'',
    @TargetSchema=N''B_improvado'',
    @TargetTable=N''unlock_monthly_campaigns'',
    @TokenizeColumns=N''__account_id,platform_campaign_id'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_improvado.youtube_organic_channels_all_videos_daily
-- Columns to tokenize: account_id,channel_id,subscribers_gained,subscribers_lost
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_improvado_youtube_organic_channels_all_videos_daily';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_improvado.youtube_organic_channels_all_videos_daily from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_improvado'',
    @SourceTable=N''youtube_organic_channels_all_videos_daily'',
    @TargetSchema=N''B_improvado'',
    @TargetTable=N''youtube_organic_channels_all_videos_daily'',
    @TokenizeColumns=N''account_id,channel_id,subscribers_gained,subscribers_lost'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_inflow.PercentAvailableHours
-- Columns to tokenize: SourceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_inflow_PercentAvailableHours';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_inflow.PercentAvailableHours from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_inflow'',
    @SourceTable=N''PercentAvailableHours'',
    @TargetSchema=N''B_inflow'',
    @TargetTable=N''PercentAvailableHours'',
    @TokenizeColumns=N''SourceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_inflow.PercentAvailableHoursPerMonth
-- Columns to tokenize: SourceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_inflow_PercentAvailableHoursPerMonth';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_inflow.PercentAvailableHoursPerMonth from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_inflow'',
    @SourceTable=N''PercentAvailableHoursPerMonth'',
    @TargetSchema=N''B_inflow'',
    @TargetTable=N''PercentAvailableHoursPerMonth'',
    @TokenizeColumns=N''SourceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_laborlytics.Total_Hours_By_Facility
-- Columns to tokenize: Actual_Paid_Hours,Paid_FTEs,SourceId,Target_Paid_Hours
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_laborlytics_Total_Hours_By_Facility';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_laborlytics.Total_Hours_By_Facility from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_laborlytics'',
    @SourceTable=N''Total_Hours_By_Facility'',
    @TargetSchema=N''B_laborlytics'',
    @TargetTable=N''Total_Hours_By_Facility'',
    @TokenizeColumns=N''Actual_Paid_Hours,Paid_FTEs,SourceId,Target_Paid_Hours'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_lawson.EDW_HR_Snapshots
-- Columns to tokenize: PROCESS_LEVEL,SourceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_lawson_EDW_HR_Snapshots';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_lawson.EDW_HR_Snapshots from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_lawson'',
    @SourceTable=N''EDW_HR_Snapshots'',
    @TargetSchema=N''B_lawson'',
    @TargetTable=N''EDW_HR_Snapshots'',
    @TokenizeColumns=N''PROCESS_LEVEL,SourceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_lawson.EmpStatus
-- Columns to tokenize: SourceId,USER_ID
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_lawson_EmpStatus';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_lawson.EmpStatus from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_lawson'',
    @SourceTable=N''EmpStatus'',
    @TargetSchema=N''B_lawson'',
    @TargetTable=N''EmpStatus'',
    @TokenizeColumns=N''SourceId,USER_ID'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_lawson.Employee
-- Columns to tokenize: EMAIL_ADDRESS,LAST_DAY_PAID,MIDDLE_INIT,MIDDLE_NAME,PROCESS_LEVEL,SourceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_lawson_Employee';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_lawson.Employee from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_lawson'',
    @SourceTable=N''Employee'',
    @TargetSchema=N''B_lawson'',
    @TargetTable=N''Employee'',
    @TokenizeColumns=N''EMAIL_ADDRESS,LAST_DAY_PAID,MIDDLE_INIT,MIDDLE_NAME,PROCESS_LEVEL,SourceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_lawson.HRHistory
-- Columns to tokenize: SourceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_lawson_HRHistory';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_lawson.HRHistory from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_lawson'',
    @SourceTable=N''HRHistory'',
    @TargetSchema=N''B_lawson'',
    @TargetTable=N''HRHistory'',
    @TokenizeColumns=N''SourceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_lawson.HRSuper
-- Columns to tokenize: SourceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_lawson_HRSuper';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_lawson.HRSuper from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_lawson'',
    @SourceTable=N''HRSuper'',
    @TargetSchema=N''B_lawson'',
    @TargetTable=N''HRSuper'',
    @TokenizeColumns=N''SourceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_lawson.HR_SNAPSHOTS
-- Columns to tokenize: BIRTHDATE,LAST_DAY_PAID,LOAD_ID,MIDDLE_INIT,MIDDLE_NAME,MKT_ID_2,PROCESS_LEVEL,SourceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_lawson_HR_SNAPSHOTS';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_lawson.HR_SNAPSHOTS from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_lawson'',
    @SourceTable=N''HR_SNAPSHOTS'',
    @TargetSchema=N''B_lawson'',
    @TargetTable=N''HR_SNAPSHOTS'',
    @TokenizeColumns=N''BIRTHDATE,LAST_DAY_PAID,LOAD_ID,MIDDLE_INIT,MIDDLE_NAME,MKT_ID_2,PROCESS_LEVEL,SourceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_lawson.JobClass
-- Columns to tokenize: SourceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_lawson_JobClass';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_lawson.JobClass from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_lawson'',
    @SourceTable=N''JobClass'',
    @TargetSchema=N''B_lawson'',
    @TargetTable=N''JobClass'',
    @TokenizeColumns=N''SourceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_lawson.JobCode
-- Columns to tokenize: BASE_MID_SAL,MID_SAL_RANGE,OBJ_ID,PROCESS_LEVEL,RATE_OVERRIDE,SourceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_lawson_JobCode';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_lawson.JobCode from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_lawson'',
    @SourceTable=N''JobCode'',
    @TargetSchema=N''B_lawson'',
    @TargetTable=N''JobCode'',
    @TokenizeColumns=N''BASE_MID_SAL,MID_SAL_RANGE,OBJ_ID,PROCESS_LEVEL,RATE_OVERRIDE,SourceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_lawson.PADict
-- Columns to tokenize: SourceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_lawson_PADict';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_lawson.PADict from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_lawson'',
    @SourceTable=N''PADict'',
    @TargetSchema=N''B_lawson'',
    @TargetTable=N''PADict'',
    @TokenizeColumns=N''SourceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_lawson.PAEmployee
-- Columns to tokenize: BIRTHDATE,HANDICAP_ID,HM_PHONE_CNTRY,HM_PHONE_NBR,MAIDEN_FST_NM,MAIDEN_LST_NM,MAIDEN_MI,SUPP_ZIP,SourceId,WK_PHONE_CNTRY,WK_PHONE_EXT,WK_PHONE_NBR
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_lawson_PAEmployee';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_lawson.PAEmployee from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_lawson'',
    @SourceTable=N''PAEmployee'',
    @TargetSchema=N''B_lawson'',
    @TargetTable=N''PAEmployee'',
    @TokenizeColumns=N''BIRTHDATE,HANDICAP_ID,HM_PHONE_CNTRY,HM_PHONE_NBR,MAIDEN_FST_NM,MAIDEN_LST_NM,MAIDEN_MI,SUPP_ZIP,SourceId,WK_PHONE_CNTRY,WK_PHONE_EXT,WK_PHONE_NBR'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_lawson.PaEmpPos
-- Columns to tokenize: SourceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_lawson_PaEmpPos';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_lawson.PaEmpPos from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_lawson'',
    @SourceTable=N''PaEmpPos'',
    @TargetSchema=N''B_lawson'',
    @TargetTable=N''PaEmpPos'',
    @TokenizeColumns=N''SourceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_lawson.Prsaghead
-- Columns to tokenize: SourceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_lawson_Prsaghead';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_lawson.Prsaghead from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_lawson'',
    @SourceTable=N''Prsaghead'',
    @TargetSchema=N''B_lawson'',
    @TargetTable=N''Prsaghead'',
    @TokenizeColumns=N''SourceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_lawson.SN_CompanyCostCenter
-- Columns to tokenize: PhoneNumber,PostalCode,SourceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_lawson_SN_CompanyCostCenter';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_lawson.SN_CompanyCostCenter from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_lawson'',
    @SourceTable=N''SN_CompanyCostCenter'',
    @TargetSchema=N''B_lawson'',
    @TargetTable=N''SN_CompanyCostCenter'',
    @TokenizeColumns=N''PhoneNumber,PostalCode,SourceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_lawson.SN_REGMKTCOSTCENTERDEPT
-- Columns to tokenize: SourceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_lawson_SN_REGMKTCOSTCENTERDEPT';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_lawson.SN_REGMKTCOSTCENTERDEPT from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_lawson'',
    @SourceTable=N''SN_REGMKTCOSTCENTERDEPT'',
    @TargetSchema=N''B_lawson'',
    @TargetTable=N''SN_REGMKTCOSTCENTERDEPT'',
    @TokenizeColumns=N''SourceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_lawson.SN_REGMKTPLLOC
-- Columns to tokenize: Processlevel,SourceId,Zip
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_lawson_SN_REGMKTPLLOC';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_lawson.SN_REGMKTPLLOC from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_lawson'',
    @SourceTable=N''SN_REGMKTPLLOC'',
    @TargetSchema=N''B_lawson'',
    @TargetTable=N''SN_REGMKTPLLOC'',
    @TokenizeColumns=N''Processlevel,SourceId,Zip'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_lawson.SN_Stacy_RegMktCostCtr
-- Columns to tokenize: SourceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_lawson_SN_Stacy_RegMktCostCtr';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_lawson.SN_Stacy_RegMktCostCtr from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_lawson'',
    @SourceTable=N''SN_Stacy_RegMktCostCtr'',
    @TargetSchema=N''B_lawson'',
    @TargetTable=N''SN_Stacy_RegMktCostCtr'',
    @TokenizeColumns=N''SourceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_lawson.SN_Stacy_RegMktPlLoc
-- Columns to tokenize: Processlevel,SourceId,Zip
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_lawson_SN_Stacy_RegMktPlLoc';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_lawson.SN_Stacy_RegMktPlLoc from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_lawson'',
    @SourceTable=N''SN_Stacy_RegMktPlLoc'',
    @TargetSchema=N''B_lawson'',
    @TargetTable=N''SN_Stacy_RegMktPlLoc'',
    @TokenizeColumns=N''Processlevel,SourceId,Zip'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_lawson.Turnover
-- Columns to tokenize: Birthdate,FirstName,LastDayPaid,LastName,LoadId,MiddleInit,MiddleName,MktId2,ProcessLevel,SourceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_lawson_Turnover';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_lawson.Turnover from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_lawson'',
    @SourceTable=N''Turnover'',
    @TargetSchema=N''B_lawson'',
    @TargetTable=N''Turnover'',
    @TokenizeColumns=N''Birthdate,FirstName,LastDayPaid,LastName,LoadId,MiddleInit,MiddleName,MktId2,ProcessLevel,SourceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_lawson.Turnover2
-- Columns to tokenize: BIRTHDATE,LAST_DAY_PAID,LOAD_ID,MIDDLE_INIT,MIDDLE_NAME,MKT_ID_2,PROCESS_LEVEL,SourceID
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_lawson_Turnover2';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_lawson.Turnover2 from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_lawson'',
    @SourceTable=N''Turnover2'',
    @TargetSchema=N''B_lawson'',
    @TargetTable=N''Turnover2'',
    @TokenizeColumns=N''BIRTHDATE,LAST_DAY_PAID,LOAD_ID,MIDDLE_INIT,MIDDLE_NAME,MKT_ID_2,PROCESS_LEVEL,SourceID'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_lawson.deptcode
-- Columns to tokenize: ProcessLevel,SourceId,UserId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_lawson_deptcode';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_lawson.deptcode from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_lawson'',
    @SourceTable=N''deptcode'',
    @TargetSchema=N''B_lawson'',
    @TargetTable=N''deptcode'',
    @TokenizeColumns=N''ProcessLevel,SourceId,UserId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_lawson.persacthst
-- Columns to tokenize: ObjId,SourceId,UserId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_lawson_persacthst';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_lawson.persacthst from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_lawson'',
    @SourceTable=N''persacthst'',
    @TargetSchema=N''B_lawson'',
    @TargetTable=N''persacthst'',
    @TokenizeColumns=N''ObjId,SourceId,UserId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_leaseharbor.LeasedAndOwnedExport
-- Columns to tokenize: Address,Fileid,Postalcode,SourceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_leaseharbor_LeasedAndOwnedExport';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_leaseharbor.LeasedAndOwnedExport from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_leaseharbor'',
    @SourceTable=N''LeasedAndOwnedExport'',
    @TargetSchema=N''B_leaseharbor'',
    @TargetTable=N''LeasedAndOwnedExport'',
    @TokenizeColumns=N''Address,Fileid,Postalcode,SourceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_location.EpicStatusTabHistory
-- Columns to tokenize: ProcName,SourceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_location_EpicStatusTabHistory';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_location.EpicStatusTabHistory from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_location'',
    @SourceTable=N''EpicStatusTabHistory'',
    @TargetSchema=N''B_location'',
    @TargetTable=N''EpicStatusTabHistory'',
    @TokenizeColumns=N''ProcName,SourceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_matomo.LiveLastVisits
-- Columns to tokenize: campaignId,daysSinceFirstVisit,daysSinceLastVisit,idSite,idVisit,idpageview,pageId,pageIdAction,result,secondsSinceFirstVisit,secondsSinceLastVisit,userId,visitConverted,visitConvertedIcon,visitCount,visitDuration,visitDurationPretty,visitEcommerceStatus,visitEcommerceStatusIcon,visitIp,visitLocalHour,visitLocalTime,visitServerHour,visitorId,visitorType,visitorTypeIcon
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_matomo_LiveLastVisits';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_matomo.LiveLastVisits from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_matomo'',
    @SourceTable=N''LiveLastVisits'',
    @TargetSchema=N''B_matomo'',
    @TargetTable=N''LiveLastVisits'',
    @TokenizeColumns=N''campaignId,daysSinceFirstVisit,daysSinceLastVisit,idSite,idVisit,idpageview,pageId,pageIdAction,result,secondsSinceFirstVisit,secondsSinceLastVisit,userId,visitConverted,visitConvertedIcon,visitCount,visitDuration,visitDurationPretty,visitEcommerceStatus,visitEcommerceStatusIcon,visitIp,visitLocalHour,visitLocalTime,visitServerHour,visitorId,visitorType,visitorTypeIcon'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_matomo.LiveLastVisits_ActionDetails
-- Columns to tokenize: idVisit,idpageview,pageId,pageIdAction
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_matomo_LiveLastVisits_ActionDetails';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_matomo.LiveLastVisits_ActionDetails from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_matomo'',
    @SourceTable=N''LiveLastVisits_ActionDetails'',
    @TargetSchema=N''B_matomo'',
    @TargetTable=N''LiveLastVisits_ActionDetails'',
    @TokenizeColumns=N''idVisit,idpageview,pageId,pageIdAction'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_matomo.LiveLastVisits_pluginsIcons
-- Columns to tokenize: idVisit
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_matomo_LiveLastVisits_pluginsIcons';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_matomo.LiveLastVisits_pluginsIcons from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_matomo'',
    @SourceTable=N''LiveLastVisits_pluginsIcons'',
    @TargetSchema=N''B_matomo'',
    @TargetTable=N''LiveLastVisits_pluginsIcons'',
    @TokenizeColumns=N''idVisit'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_matomo.LiveLastVisits_test
-- Columns to tokenize: daysSinceFirstVisit,daysSinceLastVisit,idSite,idVisit,secondsSinceFirstVisit,secondsSinceLastVisit,userId,visitConverted,visitConvertedIcon,visitCount,visitDuration,visitDurationPretty,visitEcommerceStatus,visitEcommerceStatusIcon,visitIp,visitLocalHour,visitLocalTime,visitServerHour,visitorId,visitorType,visitorTypeIcon
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_matomo_LiveLastVisits_test';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_matomo.LiveLastVisits_test from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_matomo'',
    @SourceTable=N''LiveLastVisits_test'',
    @TargetSchema=N''B_matomo'',
    @TargetTable=N''LiveLastVisits_test'',
    @TokenizeColumns=N''daysSinceFirstVisit,daysSinceLastVisit,idSite,idVisit,secondsSinceFirstVisit,secondsSinceLastVisit,userId,visitConverted,visitConvertedIcon,visitCount,visitDuration,visitDurationPretty,visitEcommerceStatus,visitEcommerceStatusIcon,visitIp,visitLocalHour,visitLocalTime,visitServerHour,visitorId,visitorType,visitorTypeIcon'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_matomo.LiveLastVisits_test_ActionDetails
-- Columns to tokenize: idVisit,idpageview,pageId,pageIdAction
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_matomo_LiveLastVisits_test_ActionDetails';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_matomo.LiveLastVisits_test_ActionDetails from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_matomo'',
    @SourceTable=N''LiveLastVisits_test_ActionDetails'',
    @TargetSchema=N''B_matomo'',
    @TargetTable=N''LiveLastVisits_test_ActionDetails'',
    @TokenizeColumns=N''idVisit,idpageview,pageId,pageIdAction'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_matomo.LiveLastVisits_test_PluginsIcons
-- Columns to tokenize: idVisit
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_matomo_LiveLastVisits_test_PluginsIcons';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_matomo.LiveLastVisits_test_PluginsIcons from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_matomo'',
    @SourceTable=N''LiveLastVisits_test_PluginsIcons'',
    @TargetSchema=N''B_matomo'',
    @TargetTable=N''LiveLastVisits_test_PluginsIcons'',
    @TokenizeColumns=N''idVisit'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_pbcs.Pbcs
-- Columns to tokenize: Account_Id,SourceID,Sub_Account_Id
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_pbcs_Pbcs';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_pbcs.Pbcs from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_pbcs'',
    @SourceTable=N''Pbcs'',
    @TargetSchema=N''B_pbcs'',
    @TargetTable=N''Pbcs'',
    @TokenizeColumns=N''Account_Id,SourceID,Sub_Account_Id'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_pghrp.ArdentDataDictionary
-- Columns to tokenize: ElementId,SourceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_pghrp_ArdentDataDictionary';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_pghrp.ArdentDataDictionary from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_pghrp'',
    @SourceTable=N''ArdentDataDictionary'',
    @TargetSchema=N''B_pghrp'',
    @TargetTable=N''ArdentDataDictionary'',
    @TokenizeColumns=N''ElementId,SourceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_powerbiaudit.PowerBIAuditLogs
-- Columns to tokenize: ActivityId,AppId,AppReportId,ArtifactId,ArtifactObjectId,CapacityId,DashboardId,DataflowId,DatasetId,DatasourceId,FolderObjectId,GatewayId,Id,ImportId,ItemId,ModelId,ObjectId,OrganizationId,PackageId,ReportId,RequestId,ResultStatus,ShareLinkId,UserId,WorkspaceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_powerbiaudit_PowerBIAuditLogs';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_powerbiaudit.PowerBIAuditLogs from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_powerbiaudit'',
    @SourceTable=N''PowerBIAuditLogs'',
    @TargetSchema=N''B_powerbiaudit'',
    @TargetTable=N''PowerBIAuditLogs'',
    @TokenizeColumns=N''ActivityId,AppId,AppReportId,ArtifactId,ArtifactObjectId,CapacityId,DashboardId,DataflowId,DatasetId,DatasourceId,FolderObjectId,GatewayId,Id,ImportId,ItemId,ModelId,ObjectId,OrganizationId,PackageId,ReportId,RequestId,ResultStatus,ShareLinkId,UserId,WorkspaceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_powerbiaudit.PowerBIAuditLogs1
-- Columns to tokenize: ActivityId,AppId,AppReportId,ArtifactId,ArtifactObjectId,CapacityId,DashboardId,DataflowId,DatasetId,DatasourceId,FolderObjectId,GatewayId,Id,ImportId,ItemId,ModelId,ObjectId,OrganizationId,PackageId,ReportId,RequestId,ResultStatus,ShareLinkId,UserId,WorkspaceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_powerbiaudit_PowerBIAuditLogs1';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_powerbiaudit.PowerBIAuditLogs1 from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_powerbiaudit'',
    @SourceTable=N''PowerBIAuditLogs1'',
    @TargetSchema=N''B_powerbiaudit'',
    @TargetTable=N''PowerBIAuditLogs1'',
    @TokenizeColumns=N''ActivityId,AppId,AppReportId,ArtifactId,ArtifactObjectId,CapacityId,DashboardId,DataflowId,DatasetId,DatasourceId,FolderObjectId,GatewayId,Id,ImportId,ItemId,ModelId,ObjectId,OrganizationId,PackageId,ReportId,RequestId,ResultStatus,ShareLinkId,UserId,WorkspaceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_powerbiaudit.PowerBIAuditLogs1_AggregatedWorkspaceInformation
-- Columns to tokenize: Id
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_powerbiaudit_PowerBIAuditLogs1_AggregatedWorkspaceInformation';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_powerbiaudit.PowerBIAuditLogs1_AggregatedWorkspaceInformation from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_powerbiaudit'',
    @SourceTable=N''PowerBIAuditLogs1_AggregatedWorkspaceInformation'',
    @TargetSchema=N''B_powerbiaudit'',
    @TargetTable=N''PowerBIAuditLogs1_AggregatedWorkspaceInformation'',
    @TokenizeColumns=N''Id'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_powerbiaudit.PowerBIAuditLogs1_AggregatedWorkspaceInformation_WorkspacesByCapacitySku
-- Columns to tokenize: Id
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_powerbiaudit_PowerBIAuditLogs1_AggregatedWorkspaceInformation_WorkspacesByCapacitySku';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_powerbiaudit.PowerBIAuditLogs1_AggregatedWorkspaceInformation_WorkspacesByCapacitySku from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_powerbiaudit'',
    @SourceTable=N''PowerBIAuditLogs1_AggregatedWorkspaceInformation_WorkspacesByCapacitySku'',
    @TargetSchema=N''B_powerbiaudit'',
    @TargetTable=N''PowerBIAuditLogs1_AggregatedWorkspaceInformation_WorkspacesByCapacitySku'',
    @TokenizeColumns=N''Id'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_powerbiaudit.PowerBIAuditLogs1_AggregatedWorkspaceInformation_WorkspacesByType
-- Columns to tokenize: Id
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_powerbiaudit_PowerBIAuditLogs1_AggregatedWorkspaceInformation_WorkspacesByType';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_powerbiaudit.PowerBIAuditLogs1_AggregatedWorkspaceInformation_WorkspacesByType from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_powerbiaudit'',
    @SourceTable=N''PowerBIAuditLogs1_AggregatedWorkspaceInformation_WorkspacesByType'',
    @TargetSchema=N''B_powerbiaudit'',
    @TargetTable=N''PowerBIAuditLogs1_AggregatedWorkspaceInformation_WorkspacesByType'',
    @TokenizeColumns=N''Id'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_powerbiaudit.PowerBIAuditLogs1_ArtifactAccessRequestInfo
-- Columns to tokenize: ArtifactLocationObjectId,Id,RequestId,RequesterUserObjectId,TenantObjectId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_powerbiaudit_PowerBIAuditLogs1_ArtifactAccessRequestInfo';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_powerbiaudit.PowerBIAuditLogs1_ArtifactAccessRequestInfo from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_powerbiaudit'',
    @SourceTable=N''PowerBIAuditLogs1_ArtifactAccessRequestInfo'',
    @TargetSchema=N''B_powerbiaudit'',
    @TargetTable=N''PowerBIAuditLogs1_ArtifactAccessRequestInfo'',
    @TokenizeColumns=N''ArtifactLocationObjectId,Id,RequestId,RequesterUserObjectId,TenantObjectId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_powerbiaudit.PowerBIAuditLogs1_ArtifactAccessRequestInfo_ArtifactOwnerInformation
-- Columns to tokenize: EmailAddress,Id,UserObjectId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_powerbiaudit_PowerBIAuditLogs1_ArtifactAccessRequestInfo_ArtifactOwnerInformation';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_powerbiaudit.PowerBIAuditLogs1_ArtifactAccessRequestInfo_ArtifactOwnerInformation from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_powerbiaudit'',
    @SourceTable=N''PowerBIAuditLogs1_ArtifactAccessRequestInfo_ArtifactOwnerInformation'',
    @TargetSchema=N''B_powerbiaudit'',
    @TargetTable=N''PowerBIAuditLogs1_ArtifactAccessRequestInfo_ArtifactOwnerInformation'',
    @TokenizeColumns=N''EmailAddress,Id,UserObjectId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_powerbiaudit.PowerBIAuditLogs1_AuditedArtifactInformation
-- Columns to tokenize: ArtifactObjectId,AuditedArtifactInformation_Id,Id
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_powerbiaudit_PowerBIAuditLogs1_AuditedArtifactInformation';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_powerbiaudit.PowerBIAuditLogs1_AuditedArtifactInformation from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_powerbiaudit'',
    @SourceTable=N''PowerBIAuditLogs1_AuditedArtifactInformation'',
    @TargetSchema=N''B_powerbiaudit'',
    @TargetTable=N''PowerBIAuditLogs1_AuditedArtifactInformation'',
    @TokenizeColumns=N''ArtifactObjectId,AuditedArtifactInformation_Id,Id'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_powerbiaudit.PowerBIAuditLogs1_DataflowAccessTokenRequestParameters
-- Columns to tokenize: Id
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_powerbiaudit_PowerBIAuditLogs1_DataflowAccessTokenRequestParameters';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_powerbiaudit.PowerBIAuditLogs1_DataflowAccessTokenRequestParameters from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_powerbiaudit'',
    @SourceTable=N''PowerBIAuditLogs1_DataflowAccessTokenRequestParameters'',
    @TargetSchema=N''B_powerbiaudit'',
    @TargetTable=N''PowerBIAuditLogs1_DataflowAccessTokenRequestParameters'',
    @TokenizeColumns=N''Id'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_powerbiaudit.PowerBIAuditLogs1_Datasets
-- Columns to tokenize: DatasetId,Id
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_powerbiaudit_PowerBIAuditLogs1_Datasets';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_powerbiaudit.PowerBIAuditLogs1_Datasets from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_powerbiaudit'',
    @SourceTable=N''PowerBIAuditLogs1_Datasets'',
    @TargetSchema=N''B_powerbiaudit'',
    @TargetTable=N''PowerBIAuditLogs1_Datasets'',
    @TokenizeColumns=N''DatasetId,Id'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_powerbiaudit.PowerBIAuditLogs1_DatasourceInformations
-- Columns to tokenize: DatasourceObjectId,GatewayObjectId,Id
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_powerbiaudit_PowerBIAuditLogs1_DatasourceInformations';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_powerbiaudit.PowerBIAuditLogs1_DatasourceInformations from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_powerbiaudit'',
    @SourceTable=N''PowerBIAuditLogs1_DatasourceInformations'',
    @TargetSchema=N''B_powerbiaudit'',
    @TargetTable=N''PowerBIAuditLogs1_DatasourceInformations'',
    @TokenizeColumns=N''DatasourceObjectId,GatewayObjectId,Id'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_powerbiaudit.PowerBIAuditLogs1_ExportedArtifactDownloadInfo
-- Columns to tokenize: ArtifactObjectId,ExportId,Id
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_powerbiaudit_PowerBIAuditLogs1_ExportedArtifactDownloadInfo';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_powerbiaudit.PowerBIAuditLogs1_ExportedArtifactDownloadInfo from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_powerbiaudit'',
    @SourceTable=N''PowerBIAuditLogs1_ExportedArtifactDownloadInfo'',
    @TargetSchema=N''B_powerbiaudit'',
    @TargetTable=N''PowerBIAuditLogs1_ExportedArtifactDownloadInfo'',
    @TokenizeColumns=N''ArtifactObjectId,ExportId,Id'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_powerbiaudit.PowerBIAuditLogs1_ExportedArtifactInfo
-- Columns to tokenize: ArtifactId,Id
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_powerbiaudit_PowerBIAuditLogs1_ExportedArtifactInfo';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_powerbiaudit.PowerBIAuditLogs1_ExportedArtifactInfo from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_powerbiaudit'',
    @SourceTable=N''PowerBIAuditLogs1_ExportedArtifactInfo'',
    @TargetSchema=N''B_powerbiaudit'',
    @TargetTable=N''PowerBIAuditLogs1_ExportedArtifactInfo'',
    @TokenizeColumns=N''ArtifactId,Id'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_powerbiaudit.PowerBIAuditLogs1_FolderAccessRequests
-- Columns to tokenize: Id,UserObjectId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_powerbiaudit_PowerBIAuditLogs1_FolderAccessRequests';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_powerbiaudit.PowerBIAuditLogs1_FolderAccessRequests from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_powerbiaudit'',
    @SourceTable=N''PowerBIAuditLogs1_FolderAccessRequests'',
    @TargetSchema=N''B_powerbiaudit'',
    @TargetTable=N''PowerBIAuditLogs1_FolderAccessRequests'',
    @TokenizeColumns=N''Id,UserObjectId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_powerbiaudit.PowerBIAuditLogs1_OrgAppPermission
-- Columns to tokenize: Id
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_powerbiaudit_PowerBIAuditLogs1_OrgAppPermission';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_powerbiaudit.PowerBIAuditLogs1_OrgAppPermission from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_powerbiaudit'',
    @SourceTable=N''PowerBIAuditLogs1_OrgAppPermission'',
    @TargetSchema=N''B_powerbiaudit'',
    @TargetTable=N''PowerBIAuditLogs1_OrgAppPermission'',
    @TokenizeColumns=N''Id'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_powerbiaudit.PowerBIAuditLogs1_Schedules
-- Columns to tokenize: Id
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_powerbiaudit_PowerBIAuditLogs1_Schedules';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_powerbiaudit.PowerBIAuditLogs1_Schedules from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_powerbiaudit'',
    @SourceTable=N''PowerBIAuditLogs1_Schedules'',
    @TargetSchema=N''B_powerbiaudit'',
    @TargetTable=N''PowerBIAuditLogs1_Schedules'',
    @TokenizeColumns=N''Id'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_powerbiaudit.PowerBIAuditLogs1_SharingInformation
-- Columns to tokenize: Id,ObjectId,RecipientEmail,TenantObjectId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_powerbiaudit_PowerBIAuditLogs1_SharingInformation';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_powerbiaudit.PowerBIAuditLogs1_SharingInformation from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_powerbiaudit'',
    @SourceTable=N''PowerBIAuditLogs1_SharingInformation'',
    @TargetSchema=N''B_powerbiaudit'',
    @TargetTable=N''PowerBIAuditLogs1_SharingInformation'',
    @TokenizeColumns=N''Id,ObjectId,RecipientEmail,TenantObjectId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_powerbiaudit.PowerBIAuditLogs1_SubscriptionDetails
-- Columns to tokenize: Id,subscriptionObjectId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_powerbiaudit_PowerBIAuditLogs1_SubscriptionDetails';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_powerbiaudit.PowerBIAuditLogs1_SubscriptionDetails from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_powerbiaudit'',
    @SourceTable=N''PowerBIAuditLogs1_SubscriptionDetails'',
    @TargetSchema=N''B_powerbiaudit'',
    @TargetTable=N''PowerBIAuditLogs1_SubscriptionDetails'',
    @TokenizeColumns=N''Id,subscriptionObjectId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_powerbiaudit.PowerBIAuditLogs1_SubscriptionSchedule
-- Columns to tokenize: Id
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_powerbiaudit_PowerBIAuditLogs1_SubscriptionSchedule';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_powerbiaudit.PowerBIAuditLogs1_SubscriptionSchedule from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_powerbiaudit'',
    @SourceTable=N''PowerBIAuditLogs1_SubscriptionSchedule'',
    @TargetSchema=N''B_powerbiaudit'',
    @TargetTable=N''PowerBIAuditLogs1_SubscriptionSchedule'',
    @TokenizeColumns=N''Id'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_powerbiaudit.PowerBIAuditLogs_AggregatedWorkspaceInformation
-- Columns to tokenize: Id
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_powerbiaudit_PowerBIAuditLogs_AggregatedWorkspaceInformation';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_powerbiaudit.PowerBIAuditLogs_AggregatedWorkspaceInformation from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_powerbiaudit'',
    @SourceTable=N''PowerBIAuditLogs_AggregatedWorkspaceInformation'',
    @TargetSchema=N''B_powerbiaudit'',
    @TargetTable=N''PowerBIAuditLogs_AggregatedWorkspaceInformation'',
    @TokenizeColumns=N''Id'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_powerbiaudit.PowerBIAuditLogs_AggregatedWorkspaceInformation_AggregatedWorkspaceInformation_WorkspacesByCapacitySku
-- Columns to tokenize: Id
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_powerbiaudit_PowerBIAuditLogs_AggregatedWorkspaceInformation_AggregatedWorkspaceInformation_WorkspacesByCapacitySku';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_powerbiaudit.PowerBIAuditLogs_AggregatedWorkspaceInformation_AggregatedWorkspaceInformation_WorkspacesByCapacitySku from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_powerbiaudit'',
    @SourceTable=N''PowerBIAuditLogs_AggregatedWorkspaceInformation_AggregatedWorkspaceInformation_WorkspacesByCapacitySku'',
    @TargetSchema=N''B_powerbiaudit'',
    @TargetTable=N''PowerBIAuditLogs_AggregatedWorkspaceInformation_AggregatedWorkspaceInformation_WorkspacesByCapacitySku'',
    @TokenizeColumns=N''Id'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_powerbiaudit.PowerBIAuditLogs_AggregatedWorkspaceInformation_AggregatedWorkspaceInformation_WorkspacesByType
-- Columns to tokenize: Id
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_powerbiaudit_PowerBIAuditLogs_AggregatedWorkspaceInformation_AggregatedWorkspaceInformation_WorkspacesByType';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_powerbiaudit.PowerBIAuditLogs_AggregatedWorkspaceInformation_AggregatedWorkspaceInformation_WorkspacesByType from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_powerbiaudit'',
    @SourceTable=N''PowerBIAuditLogs_AggregatedWorkspaceInformation_AggregatedWorkspaceInformation_WorkspacesByType'',
    @TargetSchema=N''B_powerbiaudit'',
    @TargetTable=N''PowerBIAuditLogs_AggregatedWorkspaceInformation_AggregatedWorkspaceInformation_WorkspacesByType'',
    @TokenizeColumns=N''Id'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_powerbiaudit.PowerBIAuditLogs_AggregatedWorkspaceInformation_WorkspacesByCapacitySku
-- Columns to tokenize: Id
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_powerbiaudit_PowerBIAuditLogs_AggregatedWorkspaceInformation_WorkspacesByCapacitySku';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_powerbiaudit.PowerBIAuditLogs_AggregatedWorkspaceInformation_WorkspacesByCapacitySku from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_powerbiaudit'',
    @SourceTable=N''PowerBIAuditLogs_AggregatedWorkspaceInformation_WorkspacesByCapacitySku'',
    @TargetSchema=N''B_powerbiaudit'',
    @TargetTable=N''PowerBIAuditLogs_AggregatedWorkspaceInformation_WorkspacesByCapacitySku'',
    @TokenizeColumns=N''Id'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_powerbiaudit.PowerBIAuditLogs_AggregatedWorkspaceInformation_WorkspacesByType
-- Columns to tokenize: Id
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_powerbiaudit_PowerBIAuditLogs_AggregatedWorkspaceInformation_WorkspacesByType';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_powerbiaudit.PowerBIAuditLogs_AggregatedWorkspaceInformation_WorkspacesByType from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_powerbiaudit'',
    @SourceTable=N''PowerBIAuditLogs_AggregatedWorkspaceInformation_WorkspacesByType'',
    @TargetSchema=N''B_powerbiaudit'',
    @TargetTable=N''PowerBIAuditLogs_AggregatedWorkspaceInformation_WorkspacesByType'',
    @TokenizeColumns=N''Id'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_powerbiaudit.PowerBIAuditLogs_ArtifactAccessRequestInfo
-- Columns to tokenize: ArtifactAccessRequestInfo_ArtifactLocationObjectId,ArtifactAccessRequestInfo_RequestId,ArtifactAccessRequestInfo_RequesterUserObjectId,ArtifactAccessRequestInfo_TenantObjectId,ArtifactLocationObjectId,Id,RequestId,RequesterUserObjectId,TenantObjectId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_powerbiaudit_PowerBIAuditLogs_ArtifactAccessRequestInfo';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_powerbiaudit.PowerBIAuditLogs_ArtifactAccessRequestInfo from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_powerbiaudit'',
    @SourceTable=N''PowerBIAuditLogs_ArtifactAccessRequestInfo'',
    @TargetSchema=N''B_powerbiaudit'',
    @TargetTable=N''PowerBIAuditLogs_ArtifactAccessRequestInfo'',
    @TokenizeColumns=N''ArtifactAccessRequestInfo_ArtifactLocationObjectId,ArtifactAccessRequestInfo_RequestId,ArtifactAccessRequestInfo_RequesterUserObjectId,ArtifactAccessRequestInfo_TenantObjectId,ArtifactLocationObjectId,Id,RequestId,RequesterUserObjectId,TenantObjectId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_powerbiaudit.PowerBIAuditLogs_ArtifactAccessRequestInfo_ArtifactAccessRequestInfo_ArtifactOwnerInformation
-- Columns to tokenize: EmailAddress,Id,UserObjectId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_powerbiaudit_PowerBIAuditLogs_ArtifactAccessRequestInfo_ArtifactAccessRequestInfo_ArtifactOwnerInformation';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_powerbiaudit.PowerBIAuditLogs_ArtifactAccessRequestInfo_ArtifactAccessRequestInfo_ArtifactOwnerInformation from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_powerbiaudit'',
    @SourceTable=N''PowerBIAuditLogs_ArtifactAccessRequestInfo_ArtifactAccessRequestInfo_ArtifactOwnerInformation'',
    @TargetSchema=N''B_powerbiaudit'',
    @TargetTable=N''PowerBIAuditLogs_ArtifactAccessRequestInfo_ArtifactAccessRequestInfo_ArtifactOwnerInformation'',
    @TokenizeColumns=N''EmailAddress,Id,UserObjectId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_powerbiaudit.PowerBIAuditLogs_ArtifactAccessRequestInfo_ArtifactOwnerInformation
-- Columns to tokenize: EmailAddress,Id,UserObjectId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_powerbiaudit_PowerBIAuditLogs_ArtifactAccessRequestInfo_ArtifactOwnerInformation';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_powerbiaudit.PowerBIAuditLogs_ArtifactAccessRequestInfo_ArtifactOwnerInformation from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_powerbiaudit'',
    @SourceTable=N''PowerBIAuditLogs_ArtifactAccessRequestInfo_ArtifactOwnerInformation'',
    @TargetSchema=N''B_powerbiaudit'',
    @TargetTable=N''PowerBIAuditLogs_ArtifactAccessRequestInfo_ArtifactOwnerInformation'',
    @TokenizeColumns=N''EmailAddress,Id,UserObjectId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_powerbiaudit.PowerBIAuditLogs_AuditedArtifactInformation
-- Columns to tokenize: ArtifactObjectId,AuditedArtifactInformation_ArtifactObjectId,AuditedArtifactInformation_Id,AuditedArtifactInformation_Id_Child,Id
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_powerbiaudit_PowerBIAuditLogs_AuditedArtifactInformation';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_powerbiaudit.PowerBIAuditLogs_AuditedArtifactInformation from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_powerbiaudit'',
    @SourceTable=N''PowerBIAuditLogs_AuditedArtifactInformation'',
    @TargetSchema=N''B_powerbiaudit'',
    @TargetTable=N''PowerBIAuditLogs_AuditedArtifactInformation'',
    @TokenizeColumns=N''ArtifactObjectId,AuditedArtifactInformation_ArtifactObjectId,AuditedArtifactInformation_Id,AuditedArtifactInformation_Id_Child,Id'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_powerbiaudit.PowerBIAuditLogs_DataflowAccessTokenRequestParameters
-- Columns to tokenize: Id
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_powerbiaudit_PowerBIAuditLogs_DataflowAccessTokenRequestParameters';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_powerbiaudit.PowerBIAuditLogs_DataflowAccessTokenRequestParameters from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_powerbiaudit'',
    @SourceTable=N''PowerBIAuditLogs_DataflowAccessTokenRequestParameters'',
    @TargetSchema=N''B_powerbiaudit'',
    @TargetTable=N''PowerBIAuditLogs_DataflowAccessTokenRequestParameters'',
    @TokenizeColumns=N''Id'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_powerbiaudit.PowerBIAuditLogs_Datasets
-- Columns to tokenize: DatasetId,Id
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_powerbiaudit_PowerBIAuditLogs_Datasets';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_powerbiaudit.PowerBIAuditLogs_Datasets from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_powerbiaudit'',
    @SourceTable=N''PowerBIAuditLogs_Datasets'',
    @TargetSchema=N''B_powerbiaudit'',
    @TargetTable=N''PowerBIAuditLogs_Datasets'',
    @TokenizeColumns=N''DatasetId,Id'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_powerbiaudit.PowerBIAuditLogs_DatasourceInformations
-- Columns to tokenize: DatasourceObjectId,GatewayObjectId,Id
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_powerbiaudit_PowerBIAuditLogs_DatasourceInformations';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_powerbiaudit.PowerBIAuditLogs_DatasourceInformations from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_powerbiaudit'',
    @SourceTable=N''PowerBIAuditLogs_DatasourceInformations'',
    @TargetSchema=N''B_powerbiaudit'',
    @TargetTable=N''PowerBIAuditLogs_DatasourceInformations'',
    @TokenizeColumns=N''DatasourceObjectId,GatewayObjectId,Id'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_powerbiaudit.PowerBIAuditLogs_ExportedArtifactDownloadInfo
-- Columns to tokenize: ArtifactObjectId,ExportId,ExportedArtifactDownloadInfo_ArtifactObjectId,ExportedArtifactDownloadInfo_ExportId,Id
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_powerbiaudit_PowerBIAuditLogs_ExportedArtifactDownloadInfo';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_powerbiaudit.PowerBIAuditLogs_ExportedArtifactDownloadInfo from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_powerbiaudit'',
    @SourceTable=N''PowerBIAuditLogs_ExportedArtifactDownloadInfo'',
    @TargetSchema=N''B_powerbiaudit'',
    @TargetTable=N''PowerBIAuditLogs_ExportedArtifactDownloadInfo'',
    @TokenizeColumns=N''ArtifactObjectId,ExportId,ExportedArtifactDownloadInfo_ArtifactObjectId,ExportedArtifactDownloadInfo_ExportId,Id'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_powerbiaudit.PowerBIAuditLogs_ExportedArtifactInfo
-- Columns to tokenize: ArtifactId,ExportedArtifactInfo_ArtifactId,Id
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_powerbiaudit_PowerBIAuditLogs_ExportedArtifactInfo';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_powerbiaudit.PowerBIAuditLogs_ExportedArtifactInfo from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_powerbiaudit'',
    @SourceTable=N''PowerBIAuditLogs_ExportedArtifactInfo'',
    @TargetSchema=N''B_powerbiaudit'',
    @TargetTable=N''PowerBIAuditLogs_ExportedArtifactInfo'',
    @TokenizeColumns=N''ArtifactId,ExportedArtifactInfo_ArtifactId,Id'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_powerbiaudit.PowerBIAuditLogs_FolderAccessRequests
-- Columns to tokenize: Id,UserObjectId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_powerbiaudit_PowerBIAuditLogs_FolderAccessRequests';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_powerbiaudit.PowerBIAuditLogs_FolderAccessRequests from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_powerbiaudit'',
    @SourceTable=N''PowerBIAuditLogs_FolderAccessRequests'',
    @TargetSchema=N''B_powerbiaudit'',
    @TargetTable=N''PowerBIAuditLogs_FolderAccessRequests'',
    @TokenizeColumns=N''Id,UserObjectId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_powerbiaudit.PowerBIAuditLogs_OrgAppPermission
-- Columns to tokenize: Id
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_powerbiaudit_PowerBIAuditLogs_OrgAppPermission';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_powerbiaudit.PowerBIAuditLogs_OrgAppPermission from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_powerbiaudit'',
    @SourceTable=N''PowerBIAuditLogs_OrgAppPermission'',
    @TargetSchema=N''B_powerbiaudit'',
    @TargetTable=N''PowerBIAuditLogs_OrgAppPermission'',
    @TokenizeColumns=N''Id'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_powerbiaudit.PowerBIAuditLogs_Schedules
-- Columns to tokenize: Id
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_powerbiaudit_PowerBIAuditLogs_Schedules';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_powerbiaudit.PowerBIAuditLogs_Schedules from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_powerbiaudit'',
    @SourceTable=N''PowerBIAuditLogs_Schedules'',
    @TargetSchema=N''B_powerbiaudit'',
    @TargetTable=N''PowerBIAuditLogs_Schedules'',
    @TokenizeColumns=N''Id'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_powerbiaudit.PowerBIAuditLogs_SharingInformation
-- Columns to tokenize: Id,ObjectId,RecipientEmail,TenantObjectId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_powerbiaudit_PowerBIAuditLogs_SharingInformation';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_powerbiaudit.PowerBIAuditLogs_SharingInformation from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_powerbiaudit'',
    @SourceTable=N''PowerBIAuditLogs_SharingInformation'',
    @TargetSchema=N''B_powerbiaudit'',
    @TargetTable=N''PowerBIAuditLogs_SharingInformation'',
    @TokenizeColumns=N''Id,ObjectId,RecipientEmail,TenantObjectId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_powerbiaudit.PowerBIAuditLogs_SubscriptionDetails
-- Columns to tokenize: Id,SubscriptionDetails_subscriptionObjectId,subscriptionObjectId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_powerbiaudit_PowerBIAuditLogs_SubscriptionDetails';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_powerbiaudit.PowerBIAuditLogs_SubscriptionDetails from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_powerbiaudit'',
    @SourceTable=N''PowerBIAuditLogs_SubscriptionDetails'',
    @TargetSchema=N''B_powerbiaudit'',
    @TargetTable=N''PowerBIAuditLogs_SubscriptionDetails'',
    @TokenizeColumns=N''Id,SubscriptionDetails_subscriptionObjectId,subscriptionObjectId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_powerbiaudit.PowerBIAuditLogs_SubscriptionSchedule
-- Columns to tokenize: Id
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_powerbiaudit_PowerBIAuditLogs_SubscriptionSchedule';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_powerbiaudit.PowerBIAuditLogs_SubscriptionSchedule from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_powerbiaudit'',
    @SourceTable=N''PowerBIAuditLogs_SubscriptionSchedule'',
    @TargetSchema=N''B_powerbiaudit'',
    @TargetTable=N''PowerBIAuditLogs_SubscriptionSchedule'',
    @TokenizeColumns=N''Id'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_pressganey.CAHPS_ANALYSIS
-- Columns to tokenize: CahpsAnalysisId,LoadId,SourceId,SurveyId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_pressganey_CAHPS_ANALYSIS';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_pressganey.CAHPS_ANALYSIS from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_pressganey'',
    @SourceTable=N''CAHPS_ANALYSIS'',
    @TargetSchema=N''B_pressganey'',
    @TargetTable=N''CAHPS_ANALYSIS'',
    @TokenizeColumns=N''CahpsAnalysisId,LoadId,SourceId,SurveyId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_pressganey.CAHPS_DEMOGRAPHICS
-- Columns to tokenize: CahpsDemographicsId,LoadId,SourceId,SurveyId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_pressganey_CAHPS_DEMOGRAPHICS';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_pressganey.CAHPS_DEMOGRAPHICS from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_pressganey'',
    @SourceTable=N''CAHPS_DEMOGRAPHICS'',
    @TargetSchema=N''B_pressganey'',
    @TargetTable=N''CAHPS_DEMOGRAPHICS'',
    @TokenizeColumns=N''CahpsDemographicsId,LoadId,SourceId,SurveyId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_pressganey.CAHPS_DETAILS
-- Columns to tokenize: CahpsDetailsId,LoadId,SourceId,SurveyId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_pressganey_CAHPS_DETAILS';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_pressganey.CAHPS_DETAILS from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_pressganey'',
    @SourceTable=N''CAHPS_DETAILS'',
    @TargetSchema=N''B_pressganey'',
    @TargetTable=N''CAHPS_DETAILS'',
    @TokenizeColumns=N''CahpsDetailsId,LoadId,SourceId,SurveyId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_pressganey.CAHPS_HEADER
-- Columns to tokenize: ClientId,LoadId,SourceId,SurveyId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_pressganey_CAHPS_HEADER';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_pressganey.CAHPS_HEADER from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_pressganey'',
    @SourceTable=N''CAHPS_HEADER'',
    @TargetSchema=N''B_pressganey'',
    @TargetTable=N''CAHPS_HEADER'',
    @TokenizeColumns=N''ClientId,LoadId,SourceId,SurveyId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_pressganey.CAHPS_QUESTIONS
-- Columns to tokenize: SourceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_pressganey_CAHPS_QUESTIONS';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_pressganey.CAHPS_QUESTIONS from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_pressganey'',
    @SourceTable=N''CAHPS_QUESTIONS'',
    @TargetSchema=N''B_pressganey'',
    @TargetTable=N''CAHPS_QUESTIONS'',
    @TokenizeColumns=N''SourceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_pressganey.CAHPS_RUBRIC
-- Columns to tokenize: SourceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_pressganey_CAHPS_RUBRIC';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_pressganey.CAHPS_RUBRIC from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_pressganey'',
    @SourceTable=N''CAHPS_RUBRIC'',
    @TargetSchema=N''B_pressganey'',
    @TargetTable=N''CAHPS_RUBRIC'',
    @TokenizeColumns=N''SourceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_pressganey.CAHPS_SURVEYS
-- Columns to tokenize: ClientId,EncounterNum,FacilityId,LoadId,SourceId,SurveyId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_pressganey_CAHPS_SURVEYS';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_pressganey.CAHPS_SURVEYS from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_pressganey'',
    @SourceTable=N''CAHPS_SURVEYS'',
    @TargetSchema=N''B_pressganey'',
    @TargetTable=N''CAHPS_SURVEYS'',
    @TokenizeColumns=N''ClientId,EncounterNum,FacilityId,LoadId,SourceId,SurveyId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_pressganey.CPT_CODES
-- Columns to tokenize: CptCode,CptCodesId,CptDateOfProc,CptModifier,DateOfProc,EncounterNum,FacilityId,ProfProvider,SourceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_pressganey_CPT_CODES';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_pressganey.CPT_CODES from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_pressganey'',
    @SourceTable=N''CPT_CODES'',
    @TargetSchema=N''B_pressganey'',
    @TargetTable=N''CPT_CODES'',
    @TokenizeColumns=N''CptCode,CptCodesId,CptDateOfProc,CptModifier,DateOfProc,EncounterNum,FacilityId,ProfProvider,SourceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_pressganey.FACILITY
-- Columns to tokenize: CategoryId,FacilityId,MktId3,SourceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_pressganey_FACILITY';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_pressganey.FACILITY from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_pressganey'',
    @SourceTable=N''FACILITY'',
    @TargetSchema=N''B_pressganey'',
    @TargetTable=N''FACILITY'',
    @TokenizeColumns=N''CategoryId,FacilityId,MktId3,SourceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_rwb.Measures
-- Columns to tokenize: BirthDate,Mrn,PatientName,QrdaPatientEthnicity,QrdaPatientPayer,QrdaPatientRace,QrdaPatientSex,SourceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_rwb_Measures';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_rwb.Measures from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_rwb'',
    @SourceTable=N''Measures'',
    @TargetSchema=N''B_rwb'',
    @TargetTable=N''Measures'',
    @TokenizeColumns=N''BirthDate,Mrn,PatientName,QrdaPatientEthnicity,QrdaPatientPayer,QrdaPatientRace,QrdaPatientSex,SourceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- B_rwb.MeasuresFilenameExtracts
-- Columns to tokenize: SourceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_B_rwb_MeasuresFilenameExtracts';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize B_rwb.MeasuresFilenameExtracts from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''B_rwb'',
    @SourceTable=N''MeasuresFilenameExtracts'',
    @TargetSchema=N''B_rwb'',
    @TargetTable=N''MeasuresFilenameExtracts'',
    @TokenizeColumns=N''SourceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- D_mask.PatientTokenized
-- Columns to tokenize: PatientID,SSN_Token
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_D_mask_PatientTokenized';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize D_mask.PatientTokenized from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''D_mask'',
    @SourceTable=N''PatientTokenized'',
    @TargetSchema=N''D_mask'',
    @TargetTable=N''PatientTokenized'',
    @TokenizeColumns=N''PatientID,SSN_Token'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- D_mask.PatientsDDM
-- Columns to tokenize: Email,PatientID,Phone,SSN
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_D_mask_PatientsDDM';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize D_mask.PatientsDDM from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''D_mask'',
    @SourceTable=N''PatientsDDM'',
    @TargetSchema=N''D_mask'',
    @TargetTable=N''PatientsDDM'',
    @TokenizeColumns=N''Email,PatientID,Phone,SSN'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- D_mask.Patients_SDM
-- Columns to tokenize: Email,PatientID,Phone,SSN
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_D_mask_Patients_SDM';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize D_mask.Patients_SDM from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''D_mask'',
    @SourceTable=N''Patients_SDM'',
    @TargetSchema=N''D_mask'',
    @TargetTable=N''Patients_SDM'',
    @TokenizeColumns=N''Email,PatientID,Phone,SSN'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- D_mask.Patients_prd
-- Columns to tokenize: Email,PatientID,Phone,SSN
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_D_mask_Patients_prd';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize D_mask.Patients_prd from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''D_mask'',
    @SourceTable=N''Patients_prd'',
    @TargetSchema=N''D_mask'',
    @TargetTable=N''Patients_prd'',
    @TokenizeColumns=N''Email,PatientID,Phone,SSN'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- S_clinical.AvailabilityHours
-- Columns to tokenize: Departmentid,Locationid,Providerid,Providername,SourceId,Unavailablereason
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_S_clinical_AvailabilityHours';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize S_clinical.AvailabilityHours from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''S_clinical'',
    @SourceTable=N''AvailabilityHours'',
    @TargetSchema=N''S_clinical'',
    @TargetTable=N''AvailabilityHours'',
    @TokenizeColumns=N''Departmentid,Locationid,Providerid,Providername,SourceId,Unavailablereason'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- S_clinical.CmsDiabeticBloodPressure
-- Columns to tokenize: Encounterepiccsn,Encounterkey,Patientdurablekey,Providerdurablekey,Providername,Regulatoryentityid,SourceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_S_clinical_CmsDiabeticBloodPressure';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize S_clinical.CmsDiabeticBloodPressure from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''S_clinical'',
    @SourceTable=N''CmsDiabeticBloodPressure'',
    @TargetSchema=N''S_clinical'',
    @TargetTable=N''CmsDiabeticBloodPressure'',
    @TokenizeColumns=N''Encounterepiccsn,Encounterkey,Patientdurablekey,Providerdurablekey,Providername,Regulatoryentityid,SourceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- S_clinical.FactReferral
-- Columns to tokenize: DiagnosisComboKey,FirstEncounterDateKey,FirstEncounterKey,HospitalChargeAmount,Patientkey,PrimaryDiagnosisKey,ReferralEpicId,ReferredToProviderSpecialty,SourceID
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_S_clinical_FactReferral';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize S_clinical.FactReferral from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''S_clinical'',
    @SourceTable=N''FactReferral'',
    @TargetSchema=N''S_clinical'',
    @TargetTable=N''FactReferral'',
    @TokenizeColumns=N''DiagnosisComboKey,FirstEncounterDateKey,FirstEncounterKey,HospitalChargeAmount,Patientkey,PrimaryDiagnosisKey,ReferralEpicId,ReferredToProviderSpecialty,SourceID'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- S_clinical.FilledPosition
-- Columns to tokenize: CandidateName,CandidateNpi,CandidateSign,CandidateSignYear,ProviderType,SourceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_S_clinical_FilledPosition';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize S_clinical.FilledPosition from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''S_clinical'',
    @SourceTable=N''FilledPosition'',
    @TargetSchema=N''S_clinical'',
    @TargetTable=N''FilledPosition'',
    @TokenizeColumns=N''CandidateName,CandidateNpi,CandidateSign,CandidateSignYear,ProviderType,SourceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- S_common.EpicLocation
-- Columns to tokenize: BEDID,Bedlabel,COSTCNTRID,DEPARTMENTID,Facilityid,LOCID,Posid,ROOMID,Servareaid,addressline1,addressline2,bedcsnid,processcode,regionid,roomcsnid,zip
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_S_common_EpicLocation';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize S_common.EpicLocation from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''S_common'',
    @SourceTable=N''EpicLocation'',
    @TargetSchema=N''S_common'',
    @TargetTable=N''EpicLocation'',
    @TokenizeColumns=N''BEDID,Bedlabel,COSTCNTRID,DEPARTMENTID,Facilityid,LOCID,Posid,ROOMID,Servareaid,addressline1,addressline2,bedcsnid,processcode,regionid,roomcsnid,zip'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- S_common.LawsonAddress
-- Columns to tokenize: EmailAddress,LawsonAddressKey,Phone,PhoneExt,SourceId,SuppZip,Zip
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_S_common_LawsonAddress';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize S_common.LawsonAddress from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''S_common'',
    @SourceTable=N''LawsonAddress'',
    @TargetSchema=N''S_common'',
    @TargetTable=N''LawsonAddress'',
    @TokenizeColumns=N''EmailAddress,LawsonAddressKey,Phone,PhoneExt,SourceId,SuppZip,Zip'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- S_common.LocAddress
-- Columns to tokenize: LocAddressKey,StreetAddress1,StreetAddress2,ZipCode
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_S_common_LocAddress';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize S_common.LocAddress from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''S_common'',
    @SourceTable=N''LocAddress'',
    @TargetSchema=N''S_common'',
    @TargetTable=N''LocAddress'',
    @TokenizeColumns=N''LocAddressKey,StreetAddress1,StreetAddress2,ZipCode'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- S_common.LocContact
-- Columns to tokenize: ContactFirstName,ContactLastName,ContactMiddleName
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_S_common_LocContact';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize S_common.LocContact from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''S_common'',
    @SourceTable=N''LocContact'',
    @TargetSchema=N''S_common'',
    @TargetTable=N''LocContact'',
    @TokenizeColumns=N''ContactFirstName,ContactLastName,ContactMiddleName'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- S_common.LocContactDetail
-- Columns to tokenize: Email,Phone,PhoneExtention
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_S_common_LocContactDetail';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize S_common.LocContactDetail from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''S_common'',
    @SourceTable=N''LocContactDetail'',
    @TargetSchema=N''S_common'',
    @TargetTable=N''LocContactDetail'',
    @TokenizeColumns=N''Email,Phone,PhoneExtention'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- S_common.Location
-- Columns to tokenize: LocAddressKey
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_S_common_Location';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize S_common.Location from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''S_common'',
    @SourceTable=N''Location'',
    @TargetSchema=N''S_common'',
    @TargetTable=N''Location'',
    @TokenizeColumns=N''LocAddressKey'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- S_common.LocationAlias
-- Columns to tokenize: ExternalId,SourceSystemId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_S_common_LocationAlias';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize S_common.LocationAlias from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''S_common'',
    @SourceTable=N''LocationAlias'',
    @TargetSchema=N''S_common'',
    @TargetTable=N''LocationAlias'',
    @TokenizeColumns=N''ExternalId,SourceSystemId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- S_common.PatientDim
-- Columns to tokenize: PatID,PatientKey,PrimaryCareProviderKey,PrimaryMrn,SourceID
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_S_common_PatientDim';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize S_common.PatientDim from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''S_common'',
    @SourceTable=N''PatientDim'',
    @TargetSchema=N''S_common'',
    @TargetTable=N''PatientDim'',
    @TokenizeColumns=N''PatID,PatientKey,PrimaryCareProviderKey,PrimaryMrn,SourceID'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- S_common.ProviderDim
-- Columns to tokenize: ProviderEpicId,ProviderKey,SourceID
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_S_common_ProviderDim';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize S_common.ProviderDim from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''S_common'',
    @SourceTable=N''ProviderDim'',
    @TargetSchema=N''S_common'',
    @TargetTable=N''ProviderDim'',
    @TokenizeColumns=N''ProviderEpicId,ProviderKey,SourceID'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- S_common.SN_Company
-- Columns to tokenize: ProcessLevel
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_S_common_SN_Company';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize S_common.SN_Company from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''S_common'',
    @SourceTable=N''SN_Company'',
    @TargetSchema=N''S_common'',
    @TargetTable=N''SN_Company'',
    @TokenizeColumns=N''ProcessLevel'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- S_common.SN_CompanyCostCenter
-- Columns to tokenize: PHONENUMBER,ZIPCODE
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_S_common_SN_CompanyCostCenter';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize S_common.SN_CompanyCostCenter from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''S_common'',
    @SourceTable=N''SN_CompanyCostCenter'',
    @TargetSchema=N''S_common'',
    @TargetTable=N''SN_CompanyCostCenter'',
    @TokenizeColumns=N''PHONENUMBER,ZIPCODE'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- S_common.SN_Location
-- Columns to tokenize: Zip
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_S_common_SN_Location';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize S_common.SN_Location from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''S_common'',
    @SourceTable=N''SN_Location'',
    @TargetSchema=N''S_common'',
    @TargetTable=N''SN_Location'',
    @TokenizeColumns=N''Zip'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- S_common.SN_Location_ProcessCode
-- Columns to tokenize: ProcessLevel
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_S_common_SN_Location_ProcessCode';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize S_common.SN_Location_ProcessCode from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''S_common'',
    @SourceTable=N''SN_Location_ProcessCode'',
    @TargetSchema=N''S_common'',
    @TargetTable=N''SN_Location_ProcessCode'',
    @TokenizeColumns=N''ProcessLevel'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- S_common.SN_Region_Location_ProcessCode
-- Columns to tokenize: ProcessLevel
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_S_common_SN_Region_Location_ProcessCode';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize S_common.SN_Region_Location_ProcessCode from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''S_common'',
    @SourceTable=N''SN_Region_Location_ProcessCode'',
    @TargetSchema=N''S_common'',
    @TargetTable=N''SN_Region_Location_ProcessCode'',
    @TokenizeColumns=N''ProcessLevel'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- S_operations.NPS_SpeedTable
-- Columns to tokenize: ClientId,FacilityId,Provider,ServiceTypeId,SurveyId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_S_operations_NPS_SpeedTable';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize S_operations.NPS_SpeedTable from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''S_operations'',
    @SourceTable=N''NPS_SpeedTable'',
    @TargetSchema=N''S_operations'',
    @TargetTable=N''NPS_SpeedTable'',
    @TokenizeColumns=N''ClientId,FacilityId,Provider,ServiceTypeId,SurveyId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- S_people.Total_Hours_By_Facility
-- Columns to tokenize: Actual_Paid_Hours,Paid_FTEs,SourceId,Target_Paid_Hours
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_S_people_Total_Hours_By_Facility';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize S_people.Total_Hours_By_Facility from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''S_people'',
    @SourceTable=N''Total_Hours_By_Facility'',
    @TargetSchema=N''S_people'',
    @TargetTable=N''Total_Hours_By_Facility'',
    @TokenizeColumns=N''Actual_Paid_Hours,Paid_FTEs,SourceId,Target_Paid_Hours'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- S_revenue.Pbcs
-- Columns to tokenize: Account_Id,SourceID,Sub_Account_Id
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_S_revenue_Pbcs';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize S_revenue.Pbcs from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''S_revenue'',
    @SourceTable=N''Pbcs'',
    @TargetSchema=N''S_revenue'',
    @TargetTable=N''Pbcs'',
    @TokenizeColumns=N''Account_Id,SourceID,Sub_Account_Id'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- S_revenue.Unpivot_pbcs
-- Columns to tokenize: Account_Id,SourceID,Sub_Account_Id
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_S_revenue_Unpivot_pbcs';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize S_revenue.Unpivot_pbcs from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''S_revenue'',
    @SourceTable=N''Unpivot_pbcs'',
    @TargetSchema=N''S_revenue'',
    @TargetTable=N''Unpivot_pbcs'',
    @TokenizeColumns=N''Account_Id,SourceID,Sub_Account_Id'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- S_rwb.Measures
-- Columns to tokenize: BirthDate,PatientName,QrdaPatientEthnicity,QrdaPatientPayer,QrdaPatientRace,QrdaPatientSex,mrn
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_S_rwb_Measures';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize S_rwb.Measures from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''S_rwb'',
    @SourceTable=N''Measures'',
    @TargetSchema=N''S_rwb'',
    @TargetTable=N''Measures'',
    @TokenizeColumns=N''BirthDate,PatientName,QrdaPatientEthnicity,QrdaPatientPayer,QrdaPatientRace,QrdaPatientSex,mrn'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- TERA.ETLPerfTracking
-- Columns to tokenize: LogID,ProcessName,RowsProcessed
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_TERA_ETLPerfTracking';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize TERA.ETLPerfTracking from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''TERA'',
    @SourceTable=N''ETLPerfTracking'',
    @TargetSchema=N''TERA'',
    @TargetTable=N''ETLPerfTracking'',
    @TokenizeColumns=N''LogID,ProcessName,RowsProcessed'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- TERA.ETL_Audit_Trail
-- Columns to tokenize: Audit_ID,Job_Log_ID,User_ID
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_TERA_ETL_Audit_Trail';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize TERA.ETL_Audit_Trail from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''TERA'',
    @SourceTable=N''ETL_Audit_Trail'',
    @TargetSchema=N''TERA'',
    @TargetTable=N''ETL_Audit_Trail'',
    @TokenizeColumns=N''Audit_ID,Job_Log_ID,User_ID'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- TERA.ETL_Batch_Log
-- Columns to tokenize: Batch_Log_ID,Job_Log_ID,Transformation_Rule_ID
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_TERA_ETL_Batch_Log';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize TERA.ETL_Batch_Log from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''TERA'',
    @SourceTable=N''ETL_Batch_Log'',
    @TargetSchema=N''TERA'',
    @TargetTable=N''ETL_Batch_Log'',
    @TokenizeColumns=N''Batch_Log_ID,Job_Log_ID,Transformation_Rule_ID'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- TERA.ETL_Control_Log
-- Columns to tokenize: Id
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_TERA_ETL_Control_Log';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize TERA.ETL_Control_Log from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''TERA'',
    @SourceTable=N''ETL_Control_Log'',
    @TargetSchema=N''TERA'',
    @TargetTable=N''ETL_Control_Log'',
    @TokenizeColumns=N''Id'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- TERA.ETL_Job_Log
-- Columns to tokenize: Job_Log_ID,Records_Processed
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_TERA_ETL_Job_Log';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize TERA.ETL_Job_Log from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''TERA'',
    @SourceTable=N''ETL_Job_Log'',
    @TargetSchema=N''TERA'',
    @TargetTable=N''ETL_Job_Log'',
    @TokenizeColumns=N''Job_Log_ID,Records_Processed'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- TERA.ETL_Metadata_Log
-- Columns to tokenize: DQ_Check_Result,Job_Log_ID,Metadata_Log_ID,Rule_ID
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_TERA_ETL_Metadata_Log';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize TERA.ETL_Metadata_Log from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''TERA'',
    @SourceTable=N''ETL_Metadata_Log'',
    @TargetSchema=N''TERA'',
    @TargetTable=N''ETL_Metadata_Log'',
    @TokenizeColumns=N''DQ_Check_Result,Job_Log_ID,Metadata_Log_ID,Rule_ID'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- TERA.ETL_Record_Error_Log
-- Columns to tokenize: Batch_Log_ID,Error_Log_ID,Processed_Timestamp,Record_ID
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_TERA_ETL_Record_Error_Log';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize TERA.ETL_Record_Error_Log from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''TERA'',
    @SourceTable=N''ETL_Record_Error_Log'',
    @TargetSchema=N''TERA'',
    @TargetTable=N''ETL_Record_Error_Log'',
    @TokenizeColumns=N''Batch_Log_ID,Error_Log_ID,Processed_Timestamp,Record_ID'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- TERA.EpicStatusTabHistory
-- Columns to tokenize: ProcName,SourceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_TERA_EpicStatusTabHistory';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize TERA.EpicStatusTabHistory from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''TERA'',
    @SourceTable=N''EpicStatusTabHistory'',
    @TargetSchema=N''TERA'',
    @TargetTable=N''EpicStatusTabHistory'',
    @TokenizeColumns=N''ProcName,SourceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- TERA.Executions
-- Columns to tokenize: SourceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_TERA_Executions';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize TERA.Executions from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''TERA'',
    @SourceTable=N''Executions'',
    @TargetSchema=N''TERA'',
    @TargetTable=N''Executions'',
    @TokenizeColumns=N''SourceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- TERA.SourceEtlCompletionLog
-- Columns to tokenize: SourceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_TERA_SourceEtlCompletionLog';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize TERA.SourceEtlCompletionLog from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''TERA'',
    @SourceTable=N''SourceEtlCompletionLog'',
    @TargetSchema=N''TERA'',
    @TargetTable=N''SourceEtlCompletionLog'',
    @TokenizeColumns=N''SourceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- b_poc.Employees
-- Columns to tokenize: EmployeeID,FirstName,LastName
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_b_poc_Employees';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize b_poc.Employees from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''b_poc'',
    @SourceTable=N''Employees'',
    @TargetSchema=N''b_poc'',
    @TargetTable=N''Employees'',
    @TokenizeColumns=N''EmployeeID,FirstName,LastName'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- b_poc.RoleEmployeeMapping
-- Columns to tokenize: SecurityID
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_b_poc_RoleEmployeeMapping';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize b_poc.RoleEmployeeMapping from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''b_poc'',
    @SourceTable=N''RoleEmployeeMapping'',
    @TargetSchema=N''b_poc'',
    @TargetTable=N''RoleEmployeeMapping'',
    @TokenizeColumns=N''SecurityID'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- b_poc.Salaries
-- Columns to tokenize: EmployeeID
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_b_poc_Salaries';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize b_poc.Salaries from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''b_poc'',
    @SourceTable=N''Salaries'',
    @TargetSchema=N''b_poc'',
    @TargetTable=N''Salaries'',
    @TokenizeColumns=N''EmployeeID'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- b_poc.UserEmployeeMapping
-- Columns to tokenize: SecurityID
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_b_poc_UserEmployeeMapping';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize b_poc.UserEmployeeMapping from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''b_poc'',
    @SourceTable=N''UserEmployeeMapping'',
    @TargetSchema=N''b_poc'',
    @TargetTable=N''UserEmployeeMapping'',
    @TokenizeColumns=N''SecurityID'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- b_poc.role_members_table
-- Columns to tokenize: Member_Principal_Name,member_principal_id,role_principal_id
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_b_poc_role_members_table';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize b_poc.role_members_table from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''b_poc'',
    @SourceTable=N''role_members_table'',
    @TargetSchema=N''b_poc'',
    @TargetTable=N''role_members_table'',
    @TokenizeColumns=N''Member_Principal_Name,member_principal_id,role_principal_id'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- dbo.B_illumicare.Data_all_ardent_2025_07_10
-- Columns to tokenize: admission_datetime,core_providers,current_result_normality,dif_identified_to_end,discharge_datetime,mrn,patient_class,patient_product_tk,prior_result_normality,provider_name,ribbon_illumination_candidate,spotlight_illumination_candidate,visit_number
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_dbo_B_illumicare.Data_all_ardent_2025_07_10';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize dbo.B_illumicare.Data_all_ardent_2025_07_10 from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''dbo'',
    @SourceTable=N''B_illumicare.Data_all_ardent_2025_07_10'',
    @TargetSchema=N''dbo'',
    @TargetTable=N''B_illumicare.Data_all_ardent_2025_07_10'',
    @TokenizeColumns=N''admission_datetime,core_providers,current_result_normality,dif_identified_to_end,discharge_datetime,mrn,patient_class,patient_product_tk,prior_result_normality,provider_name,ribbon_illumination_candidate,spotlight_illumination_candidate,visit_number'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- dbo.B_illumicare.Data_all_ardent_2025_07_10v2
-- Columns to tokenize: admission_datetime,core_providers,current_result_normality,dif_identified_to_end,discharge_datetime,mrn,patient_class,patient_product_tk,prior_result_normality,provider_name,ribbon_illumination_candidate,spotlight_illumination_candidate,visit_number
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_dbo_B_illumicare.Data_all_ardent_2025_07_10v2';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize dbo.B_illumicare.Data_all_ardent_2025_07_10v2 from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''dbo'',
    @SourceTable=N''B_illumicare.Data_all_ardent_2025_07_10v2'',
    @TargetSchema=N''dbo'',
    @TargetTable=N''B_illumicare.Data_all_ardent_2025_07_10v2'',
    @TokenizeColumns=N''admission_datetime,core_providers,current_result_normality,dif_identified_to_end,discharge_datetime,mrn,patient_class,patient_product_tk,prior_result_normality,provider_name,ribbon_illumination_candidate,spotlight_illumination_candidate,visit_number'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- dbo.S_ZZ_Update Data
-- Columns to tokenize: ProviderEpicId,ProviderKey,SourceID
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_dbo_S_ZZ_Update Data';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize dbo.S_ZZ_Update Data from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''dbo'',
    @SourceTable=N''S_ZZ_Update Data'',
    @TargetSchema=N''dbo'',
    @TargetTable=N''S_ZZ_Update Data'',
    @TokenizeColumns=N''ProviderEpicId,ProviderKey,SourceID'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- dbo.TermQuestionMetaDataDetail
-- Columns to tokenize: QuestionDetailID,QuestionMasterID
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_dbo_TermQuestionMetaDataDetail';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize dbo.TermQuestionMetaDataDetail from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''dbo'',
    @SourceTable=N''TermQuestionMetaDataDetail'',
    @TargetSchema=N''dbo'',
    @TargetTable=N''TermQuestionMetaDataDetail'',
    @TokenizeColumns=N''QuestionDetailID,QuestionMasterID'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- dbo.Unpivot_pbcs
-- Columns to tokenize: Account_Id,SourceID,Sub_Account_Id
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_dbo_Unpivot_pbcs';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize dbo.Unpivot_pbcs from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''dbo'',
    @SourceTable=N''Unpivot_pbcs'',
    @TargetSchema=N''dbo'',
    @TargetTable=N''Unpivot_pbcs'',
    @TokenizeColumns=N''Account_Id,SourceID,Sub_Account_Id'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- dbo.ZZ_POS
-- Columns to tokenize: DiagnosisComboKey,FirstEncounterDateKey,FirstEncounterKey,HospitalChargeAmount,Patientkey,PrimaryDiagnosisKey,ReferralEpicId,ReferredToProviderSpecialty,SourceID
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_dbo_ZZ_POS';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize dbo.ZZ_POS from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''dbo'',
    @SourceTable=N''ZZ_POS'',
    @TargetSchema=N''dbo'',
    @TargetTable=N''ZZ_POS'',
    @TokenizeColumns=N''DiagnosisComboKey,FirstEncounterDateKey,FirstEncounterKey,HospitalChargeAmount,Patientkey,PrimaryDiagnosisKey,ReferralEpicId,ReferredToProviderSpecialty,SourceID'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- dbo.ZZ_Update Data
-- Columns to tokenize: PatID,PatientKey,PrimaryCareProviderKey,PrimaryMrn,SourceId
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_dbo_ZZ_Update Data';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize dbo.ZZ_Update Data from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''dbo'',
    @SourceTable=N''ZZ_Update Data'',
    @TargetSchema=N''dbo'',
    @TargetTable=N''ZZ_Update Data'',
    @TokenizeColumns=N''PatID,PatientKey,PrimaryCareProviderKey,PrimaryMrn,SourceId'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- dbo.cross_channel_model_ai
-- Columns to tokenize: ad_id,adset_id,advertiser_id,campaign_id,creative_id,placement_id,video_100_quartile_views,video_25_quartile_views,video_50_quartile_views,video_75_quartile_views,video_starts,video_views
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_dbo_cross_channel_model_ai';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize dbo.cross_channel_model_ai from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''dbo'',
    @SourceTable=N''cross_channel_model_ai'',
    @TargetSchema=N''dbo'',
    @TargetTable=N''cross_channel_model_ai'',
    @TokenizeColumns=N''ad_id,adset_id,advertiser_id,campaign_id,creative_id,placement_id,video_100_quartile_views,video_25_quartile_views,video_50_quartile_views,video_75_quartile_views,video_starts,video_views'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- dbo.facebook_ads_ads_creative
-- Columns to tokenize: account_id,ad_id,adset_id,campaign_id,caption,catalog_mobile_add_to_cart,catalog_mobile_add_to_cart_value,catalog_mobile_content_view,catalog_mobile_content_view_value,catalog_mobile_purchase,catalog_mobile_purchase_value,creative_id,creative_instagram_actor_id,creative_page_id,effective_instagram_media_id,effective_object_story_id,fb_mobile_add_payment_info,fb_mobile_complete_registration,fb_mobile_content_view,fb_mobile_purchase,instagram_user_id,lead_gen_form_id,mobile_app_install,mobile_click_through,mobile_view_through,object_story_id,schedule_mobile_app,source_instagram_media_id,start_trial_mobile_app,video_30_sec_watched_actions,video_avg_time_watched_actions,video_creative_destination_url,video_p100_watched_actions,video_p25_watched_actions,video_p50_watched_actions,video_p75_watched_actions,video_p95_watched_actions,video_play_actions_view_value,video_play_actions_view_value_7d_click,video_view_3s,video_view_3s_7d_click
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_dbo_facebook_ads_ads_creative';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize dbo.facebook_ads_ads_creative from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''dbo'',
    @SourceTable=N''facebook_ads_ads_creative'',
    @TargetSchema=N''dbo'',
    @TargetTable=N''facebook_ads_ads_creative'',
    @TokenizeColumns=N''account_id,ad_id,adset_id,campaign_id,caption,catalog_mobile_add_to_cart,catalog_mobile_add_to_cart_value,catalog_mobile_content_view,catalog_mobile_content_view_value,catalog_mobile_purchase,catalog_mobile_purchase_value,creative_id,creative_instagram_actor_id,creative_page_id,effective_instagram_media_id,effective_object_story_id,fb_mobile_add_payment_info,fb_mobile_complete_registration,fb_mobile_content_view,fb_mobile_purchase,instagram_user_id,lead_gen_form_id,mobile_app_install,mobile_click_through,mobile_view_through,object_story_id,schedule_mobile_app,source_instagram_media_id,start_trial_mobile_app,video_30_sec_watched_actions,video_avg_time_watched_actions,video_creative_destination_url,video_p100_watched_actions,video_p25_watched_actions,video_p50_watched_actions,video_p75_watched_actions,video_p95_watched_actions,video_play_actions_view_value,video_play_actions_view_value_7d_click,video_view_3s,video_view_3s_7d_click'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- dbo.facebook_pages_page
-- Columns to tokenize: account_id,page_consumptions_by_video_play,page_consumptions_by_video_play_unique,page_fan_adds_by_paid_non_paid_unique_paid,page_fan_adds_by_paid_non_paid_unique_unpaid,page_id,page_impressions_paid,page_impressions_paid_unique,page_negative_feedback_by_hide_all_clicks,page_negative_feedback_by_hide_all_clicks_unique,page_negative_feedback_by_hide_clicks,page_negative_feedback_by_hide_clicks_unique,page_video_views_organic,page_video_views_paid,page_video_views_unique
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_dbo_facebook_pages_page';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize dbo.facebook_pages_page from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''dbo'',
    @SourceTable=N''facebook_pages_page'',
    @TargetSchema=N''dbo'',
    @TargetTable=N''facebook_pages_page'',
    @TokenizeColumns=N''account_id,page_consumptions_by_video_play,page_consumptions_by_video_play_unique,page_fan_adds_by_paid_non_paid_unique_paid,page_fan_adds_by_paid_non_paid_unique_unpaid,page_id,page_impressions_paid,page_impressions_paid_unique,page_negative_feedback_by_hide_all_clicks,page_negative_feedback_by_hide_all_clicks_unique,page_negative_feedback_by_hide_clicks,page_negative_feedback_by_hide_clicks_unique,page_video_views_organic,page_video_views_paid,page_video_views_unique'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- dbo.google_ads_ads
-- Columns to tokenize: account_id,ad_group_ad_label_ids,ad_group_ad_labels,ad_group_id,ad_group_labels,ad_id,ad_mobile_final_url,campaign_id,campaign_label_ids,campaign_label_names,customer_id,image_ad_pixel_width,responsive_display_ad_marketing_image_id,responsive_display_ad_square_logo_image_id,video_quartile_100,video_quartile_25,video_quartile_50,video_quartile_75,video_views
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_dbo_google_ads_ads';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize dbo.google_ads_ads from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''dbo'',
    @SourceTable=N''google_ads_ads'',
    @TargetSchema=N''dbo'',
    @TargetTable=N''google_ads_ads'',
    @TokenizeColumns=N''account_id,ad_group_ad_label_ids,ad_group_ad_labels,ad_group_id,ad_group_labels,ad_id,ad_mobile_final_url,campaign_id,campaign_label_ids,campaign_label_names,customer_id,image_ad_pixel_width,responsive_display_ad_marketing_image_id,responsive_display_ad_square_logo_image_id,video_quartile_100,video_quartile_25,video_quartile_50,video_quartile_75,video_views'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- dbo.google_ads_campaign
-- Columns to tokenize: account_id,bid_strategy_id,bid_strategy_name,bid_strategy_type,campaign_id,campaign_label_ids,campaign_labels,client_manager_id,customer_id,video_quartile_p100,video_quartile_p25,video_quartile_p50,video_quartile_p75,video_views
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_dbo_google_ads_campaign';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize dbo.google_ads_campaign from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''dbo'',
    @SourceTable=N''google_ads_campaign'',
    @TargetSchema=N''dbo'',
    @TargetTable=N''google_ads_campaign'',
    @TokenizeColumns=N''account_id,bid_strategy_id,bid_strategy_name,bid_strategy_type,campaign_id,campaign_label_ids,campaign_labels,client_manager_id,customer_id,video_quartile_p100,video_quartile_p25,video_quartile_p50,video_quartile_p75,video_views'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- dbo.src_improvado_currency_exchange_rates
-- Columns to tokenize: currency_exchange_daily_grain_id
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_dbo_src_improvado_currency_exchange_rates';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize dbo.src_improvado_currency_exchange_rates from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''dbo'',
    @SourceTable=N''src_improvado_currency_exchange_rates'',
    @TargetSchema=N''dbo'',
    @TargetTable=N''src_improvado_currency_exchange_rates'',
    @TokenizeColumns=N''currency_exchange_daily_grain_id'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- dbo.src_improvado_dataflow_run_events
-- Columns to tokenize: agency_id,agency_uuid,dataflow_id,dataflow_run_id,datasource_connection_id,datasource_connection_uid,datasource_remote_account_id,dts_agency_whitelabel_host,dts_datatable_id,order_id,workspace_id
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_dbo_src_improvado_dataflow_run_events';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize dbo.src_improvado_dataflow_run_events from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''dbo'',
    @SourceTable=N''src_improvado_dataflow_run_events'',
    @TargetSchema=N''dbo'',
    @TargetTable=N''src_improvado_dataflow_run_events'',
    @TokenizeColumns=N''agency_id,agency_uuid,dataflow_id,dataflow_run_id,datasource_connection_id,datasource_connection_uid,datasource_remote_account_id,dts_agency_whitelabel_host,dts_datatable_id,order_id,workspace_id'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- dbo.src_improvado_order_runs_billing
-- Columns to tokenize: agency_id,agency_uuid,agreement_id,billing_grain_id,company_domain_id,datasource_account_id,datasource_remote_account_id,datatable_id,notification_email,order_id,order_run_processed_rows,whitelabel_host,whitelabel_id,whitelabel_name,whitelabel_title,workspace_id
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_dbo_src_improvado_order_runs_billing';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize dbo.src_improvado_order_runs_billing from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''dbo'',
    @SourceTable=N''src_improvado_order_runs_billing'',
    @TargetSchema=N''dbo'',
    @TargetTable=N''src_improvado_order_runs_billing'',
    @TokenizeColumns=N''agency_id,agency_uuid,agreement_id,billing_grain_id,company_domain_id,datasource_account_id,datasource_remote_account_id,datatable_id,notification_email,order_id,order_run_processed_rows,whitelabel_host,whitelabel_id,whitelabel_name,whitelabel_title,workspace_id'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- dbo.sysdiagrams
-- Columns to tokenize: diagram_id,principal_id
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_dbo_sysdiagrams';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize dbo.sysdiagrams from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''dbo'',
    @SourceTable=N''sysdiagrams'',
    @TargetSchema=N''dbo'',
    @TargetTable=N''sysdiagrams'',
    @TokenizeColumns=N''diagram_id,principal_id'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- dbo.sysssislog
-- Columns to tokenize: executionid,id,sourceid
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_dbo_sysssislog';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize dbo.sysssislog from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''dbo'',
    @SourceTable=N''sysssislog'',
    @TargetSchema=N''dbo'',
    @TargetTable=N''sysssislog'',
    @TokenizeColumns=N''executionid,id,sourceid'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- dbo.test
-- Columns to tokenize: account_id
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_dbo_test';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize dbo.test from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''dbo'',
    @SourceTable=N''test'',
    @TargetSchema=N''dbo'',
    @TargetTable=N''test'',
    @TokenizeColumns=N''account_id'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- dbo.unlock_daily_agerange
-- Columns to tokenize: __account_id,platform_campaign_id
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_dbo_unlock_daily_agerange';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize dbo.unlock_daily_agerange from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''dbo'',
    @SourceTable=N''unlock_daily_agerange'',
    @TargetSchema=N''dbo'',
    @TargetTable=N''unlock_daily_agerange'',
    @TokenizeColumns=N''__account_id,platform_campaign_id'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- dbo.unlock_daily_devicestats
-- Columns to tokenize: __account_id,ad_group_id,creative_id,platform_campaign_id
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_dbo_unlock_daily_devicestats';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize dbo.unlock_daily_devicestats from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''dbo'',
    @SourceTable=N''unlock_daily_devicestats'',
    @TargetSchema=N''dbo'',
    @TargetTable=N''unlock_daily_devicestats'',
    @TokenizeColumns=N''__account_id,ad_group_id,creative_id,platform_campaign_id'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- dbo.unlock_daily_engagementstats
-- Columns to tokenize: __account_id,adgroup_id,creative_id,platform_campaign_id
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_dbo_unlock_daily_engagementstats';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize dbo.unlock_daily_engagementstats from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''dbo'',
    @SourceTable=N''unlock_daily_engagementstats'',
    @TargetSchema=N''dbo'',
    @TargetTable=N''unlock_daily_engagementstats'',
    @TokenizeColumns=N''__account_id,adgroup_id,creative_id,platform_campaign_id'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- dbo.unlock_daily_genderstats
-- Columns to tokenize: __account_id,platform_campaign_id
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_dbo_unlock_daily_genderstats';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize dbo.unlock_daily_genderstats from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''dbo'',
    @SourceTable=N''unlock_daily_genderstats'',
    @TargetSchema=N''dbo'',
    @TargetTable=N''unlock_daily_genderstats'',
    @TokenizeColumns=N''__account_id,platform_campaign_id'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- dbo.unlock_daily_geostats
-- Columns to tokenize: __account_id,platform_campaign_id,video_views,zip
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_dbo_unlock_daily_geostats';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize dbo.unlock_daily_geostats from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''dbo'',
    @SourceTable=N''unlock_daily_geostats'',
    @TargetSchema=N''dbo'',
    @TargetTable=N''unlock_daily_geostats'',
    @TokenizeColumns=N''__account_id,platform_campaign_id,video_views,zip'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- dbo.unlock_daily_keywordstats
-- Columns to tokenize: __account_id,ad_group_id,platform_campaign_id
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_dbo_unlock_daily_keywordstats';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize dbo.unlock_daily_keywordstats from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''dbo'',
    @SourceTable=N''unlock_daily_keywordstats'',
    @TargetSchema=N''dbo'',
    @TargetTable=N''unlock_daily_keywordstats'',
    @TokenizeColumns=N''__account_id,ad_group_id,platform_campaign_id'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- dbo.unlock_monthly_campaigns
-- Columns to tokenize: __account_id,platform_campaign_id
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_dbo_unlock_monthly_campaigns';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize dbo.unlock_monthly_campaigns from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''dbo'',
    @SourceTable=N''unlock_monthly_campaigns'',
    @TargetSchema=N''dbo'',
    @TargetTable=N''unlock_monthly_campaigns'',
    @TokenizeColumns=N''__account_id,platform_campaign_id'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- kpi.KPI
-- Columns to tokenize: KPIID,PriorityID
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_kpi_KPI';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize kpi.KPI from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''kpi'',
    @SourceTable=N''KPI'',
    @TargetSchema=N''kpi'',
    @TargetTable=N''KPI'',
    @TokenizeColumns=N''KPIID,PriorityID'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- kpi.Objective
-- Columns to tokenize: ObjectID,PillarID
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_kpi_Objective';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize kpi.Objective from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''kpi'',
    @SourceTable=N''Objective'',
    @TargetSchema=N''kpi'',
    @TargetTable=N''Objective'',
    @TokenizeColumns=N''ObjectID,PillarID'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- kpi.Pillar
-- Columns to tokenize: PillarID
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_kpi_Pillar';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize kpi.Pillar from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''kpi'',
    @SourceTable=N''Pillar'',
    @TargetSchema=N''kpi'',
    @TargetTable=N''Pillar'',
    @TokenizeColumns=N''PillarID'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- kpi.Priority
-- Columns to tokenize: ObjectID,PriorityID
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_kpi_Priority';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize kpi.Priority from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''kpi'',
    @SourceTable=N''Priority'',
    @TargetSchema=N''kpi'',
    @TargetTable=N''Priority'',
    @TokenizeColumns=N''ObjectID,PriorityID'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO

-- ---------------------------------------------------------------------------
-- test.S_common_clarityser_sourceid
-- Columns to tokenize: PROVID,SourceSystemID,USERID
-- ---------------------------------------------------------------------------
DECLARE @jobname sysname = N'Job_CopyAndTokenize_test_S_common_clarityser_sourceid';
DECLARE @scheduleName sysname = N'Sched_Nightly_1AM';
DECLARE @command nvarchar(max);

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @jobname)
BEGIN
    EXEC msdb.dbo.sp_add_job @job_name=@jobname, @enabled=1, @description=N'Copy & Tokenize test.S_common_clarityser_sourceid from PROD to NON-PROD';
END

SET @command = N'
USE [YourNonProdDb];
EXEC dbo.usp_CopyAndTokenize_NoPS
    @SourceDb=N''YourProdDb'',
    @SourceSchema=N''test'',
    @SourceTable=N''S_common_clarityser_sourceid'',
    @TargetSchema=N''test'',
    @TargetTable=N''S_common_clarityser_sourceid'',
    @TokenizeColumns=N''PROVID,SourceSystemID,USERID'';
';

IF NOT EXISTS (
    SELECT 1 FROM msdb.dbo.sysjobsteps 
    WHERE step_name = N'S1_CopyAndTokenize' 
      AND (SELECT job_id FROM msdb.dbo.sysjobs WHERE name=@jobname)=job_id
)
BEGIN
    EXEC msdb.dbo.sp_add_jobstep
        @job_name=@jobname,
        @step_name=N'S1_CopyAndTokenize',
        @subsystem=N'TSQL',
        @database_name=N'master',
        @command=@command,
        @on_success_action=1,
        @on_fail_action=2;
END

IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysschedules WHERE name=@scheduleName)
BEGIN
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name=@scheduleName,
        @enabled=1,
        @freq_type=4,
        @freq_interval=1,
        @active_start_time=010000;
END

IF NOT EXISTS (
    SELECT 1
    FROM msdb.dbo.sysjobs j
    JOIN msdb.dbo.sysjobschedules js ON js.job_id=j.job_id
    JOIN msdb.dbo.sysschedules s ON s.schedule_id=js.schedule_id
    WHERE j.name=@jobname AND s.name=@scheduleName
)
BEGIN
    EXEC msdb.dbo.sp_attach_schedule @job_name=@jobname, @schedule_name=@scheduleName;
END

EXEC msdb.dbo.sp_add_jobserver @job_name=@jobname, @server_name=@@SERVERNAME;
GO
