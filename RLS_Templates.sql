-- =============================================================
-- Row-Level Security (RLS) TEMPLATE SCRIPT
-- Creates a role & facility-scope model. Adjust to your org needs.
-- =============================================================
GO
CREATE SCHEMA sec AUTHORIZATION dbo;
GO

-- Roles: grant these to AD groups or SQL users
CREATE ROLE role_Clinician_FullPHI;
CREATE ROLE role_BI_Reader_Masked;
CREATE ROLE role_Analyst_Restricted;
GO

-- Optional: User-to-facility mapping (for CCN scoping).
CREATE TABLE sec.UserFacility (
  PrincipalName sysname NOT NULL,
  CCN          nvarchar(32) NOT NULL,
  CONSTRAINT PK_UserFacility PRIMARY KEY (PrincipalName, CCN)
);
GO

-- Predicate: allow access if user is Clinician, or if BI_Reader/Analyst and
-- the row CCN matches a mapping entry in sec.UserFacility. If a table doesn't
-- have CCN, simplify the predicate accordingly.
CREATE FUNCTION sec.fn_allow_row (@CCN nvarchar(32))
RETURNS TABLE
WITH SCHEMABINDING
AS
RETURN
  SELECT 1 AS allow_row
  WHERE (IS_MEMBER('role_Clinician_FullPHI') = 1)
     OR (IS_MEMBER('role_BI_Reader_Masked') = 1 AND EXISTS (
            SELECT 1 FROM sec.UserFacility uf
            WHERE uf.PrincipalName = SUSER_SNAME() AND uf.CCN = @CCN
         ))
     OR (IS_MEMBER('role_Analyst_Restricted') = 1 AND EXISTS (
            SELECT 1 FROM sec.UserFacility uf
            WHERE uf.PrincipalName = SUSER_SNAME() AND uf.CCN = @CCN
         ));
GO

-- Security policy for [B_epic].[ClarityBed]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_epic_ClarityBed;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_epic_ClarityBed
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_epic].[ClarityBed]
WITH (STATE = ON);
GO

-- Security policy for [B_epic].[ClarityPos]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_epic_ClarityPos;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_epic_ClarityPos
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_epic].[ClarityPos]
WITH (STATE = ON);
GO

-- Security policy for [B_epic].[ClaritySerAddr]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_epic_ClaritySerAddr;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_epic_ClaritySerAddr
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_epic].[ClaritySerAddr]
WITH (STATE = ON);
GO

-- Security policy for [B_epic].[FactEncounter]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_epic_FactEncounter;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_epic_FactEncounter
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_epic].[FactEncounter]
WITH (STATE = ON);
GO

-- Security policy for [B_epic].[FactReferral]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_epic_FactReferral;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_epic_FactReferral
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_epic].[FactReferral]
WITH (STATE = ON);
GO

-- Security policy for [B_epic].[FactVisit]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_epic_FactVisit;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_epic_FactVisit
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_epic].[FactVisit]
WITH (STATE = ON);
GO

-- Security policy for [B_epic].[ICDCode]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_epic_ICDCode;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_epic_ICDCode
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_epic].[ICDCode]
WITH (STATE = ON);
GO

-- Security policy for [B_epic].[InsuranceClass]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_epic_InsuranceClass;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_epic_InsuranceClass
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_epic].[InsuranceClass]
WITH (STATE = ON);
GO

-- Security policy for [B_epic].[Patient]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_epic_Patient;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_epic_Patient
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_epic].[Patient]
WITH (STATE = ON);
GO

-- Security policy for [B_epic].[PatientDim]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_epic_PatientDim;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_epic_PatientDim
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_epic].[PatientDim]
WITH (STATE = ON);
GO

-- Security policy for [B_epic].[QualityOutcomeFact]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_epic_QualityOutcomeFact;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_epic_QualityOutcomeFact
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_epic].[QualityOutcomeFact]
WITH (STATE = ON);
GO

-- Security policy for [B_epic].[TeraAvailability]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_epic_TeraAvailability;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_epic_TeraAvailability
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_epic].[TeraAvailability]
WITH (STATE = ON);
GO

-- Security policy for [B_epic].[VTeraAvailability]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_epic_VTeraAvailability;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_epic_VTeraAvailability
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_epic].[VTeraAvailability]
WITH (STATE = ON);
GO

-- Security policy for [B_epic].[VTeraAvailability_backup]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_epic_VTeraAvailability_backup;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_epic_VTeraAvailability_backup
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_epic].[VTeraAvailability_backup]
WITH (STATE = ON);
GO

-- Security policy for [B_five9].[ACD_Report]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_five9_ACD_Report;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_five9_ACD_Report
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_five9].[ACD_Report]
WITH (STATE = ON);
GO

-- Security policy for [B_five9].[ACD_Report_new]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_five9_ACD_Report_new;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_five9_ACD_Report_new
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_five9].[ACD_Report_new]
WITH (STATE = ON);
GO

-- Security policy for [B_five9].[Agent_Report]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_five9_Agent_Report;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_five9_Agent_Report
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_five9].[Agent_Report]
WITH (STATE = ON);
GO

-- Security policy for [B_five9].[Agent_Report_new]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_five9_Agent_Report_new;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_five9_Agent_Report_new
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_five9].[Agent_Report_new]
WITH (STATE = ON);
GO

-- Security policy for [B_five9].[AgentState]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_five9_AgentState;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_five9_AgentState
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_five9].[AgentState]
WITH (STATE = ON);
GO

-- Security policy for [B_five9].[AgentStatistics]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_five9_AgentStatistics;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_five9_AgentStatistics
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_five9].[AgentStatistics]
WITH (STATE = ON);
GO

-- Security policy for [B_five9].[CalllogReport]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_five9_CalllogReport;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_five9_CalllogReport
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_five9].[CalllogReport]
WITH (STATE = ON);
GO

-- Security policy for [B_five9].[Callog_Report_new]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_five9_Callog_Report_new;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_five9_Callog_Report_new
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_five9].[Callog_Report_new]
WITH (STATE = ON);
GO

-- Security policy for [B_five9].[InboundCamoaignStatistics]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_five9_InboundCamoaignStatistics;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_five9_InboundCamoaignStatistics
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_five9].[InboundCamoaignStatistics]
WITH (STATE = ON);
GO

-- Security policy for [B_five9].[OutboundCampaignStatistics]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_five9_OutboundCampaignStatistics;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_five9_OutboundCampaignStatistics
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_five9].[OutboundCampaignStatistics]
WITH (STATE = ON);
GO

-- Security policy for [B_iam].[srcAD]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_iam_srcAD;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_iam_srcAD
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_iam].[srcAD]
WITH (STATE = ON);
GO

-- Security policy for [B_iam].[srcADgroups]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_iam_srcADgroups;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_iam_srcADgroups
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_iam].[srcADgroups]
WITH (STATE = ON);
GO

-- Security policy for [B_iam].[srcAya]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_iam_srcAya;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_iam_srcAya
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_iam].[srcAya]
WITH (STATE = ON);
GO

-- Security policy for [B_iam].[srcEnsemble]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_iam_srcEnsemble;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_iam_srcEnsemble
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_iam].[srcEnsemble]
WITH (STATE = ON);
GO

-- Security policy for [B_iam].[srcEpicAccounts]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_iam_srcEpicAccounts;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_iam_srcEpicAccounts
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_iam].[srcEpicAccounts]
WITH (STATE = ON);
GO

-- Security policy for [B_iam].[srcLawson]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_iam_srcLawson;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_iam_srcLawson
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_iam].[srcLawson]
WITH (STATE = ON);
GO

-- Security policy for [B_iam].[srcLawsonPositions]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_iam_srcLawsonPositions;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_iam_srcLawsonPositions
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_iam].[srcLawsonPositions]
WITH (STATE = ON);
GO

-- Security policy for [B_iam].[srcManagers]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_iam_srcManagers;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_iam_srcManagers
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_iam].[srcManagers]
WITH (STATE = ON);
GO

-- Security policy for [B_iam].[srcNorthcampus]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_iam_srcNorthcampus;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_iam_srcNorthcampus
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_iam].[srcNorthcampus]
WITH (STATE = ON);
GO

-- Security policy for [B_iam].[srcSodexo]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_iam_srcSodexo;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_iam_srcSodexo
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_iam].[srcSodexo]
WITH (STATE = ON);
GO

-- Security policy for [B_iam].[srcSymplr]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_iam_srcSymplr;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_iam_srcSymplr
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_iam].[srcSymplr]
WITH (STATE = ON);
GO

-- Security policy for [B_icims].[Icims]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_icims_Icims;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_icims_Icims
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_icims].[Icims]
WITH (STATE = ON);
GO

-- Security policy for [B_improvado].[callrail_calls]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_improvado_callrail_calls;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_improvado_callrail_calls
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_improvado].[callrail_calls]
WITH (STATE = ON);
GO

-- Security policy for [B_improvado].[dim_ai_notebooks_meta]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_improvado_dim_ai_notebooks_meta;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_improvado_dim_ai_notebooks_meta
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_improvado].[dim_ai_notebooks_meta]
WITH (STATE = ON);
GO

-- Security policy for [B_improvado].[facebook_ads_ads_creative]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_improvado_facebook_ads_ads_creative;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_improvado_facebook_ads_ads_creative
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_improvado].[facebook_ads_ads_creative]
WITH (STATE = ON);
GO

-- Security policy for [B_improvado].[google_ads_ads]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_improvado_google_ads_ads;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_improvado_google_ads_ads
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_improvado].[google_ads_ads]
WITH (STATE = ON);
GO

-- Security policy for [B_improvado].[google_ads_campaign]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_improvado_google_ads_campaign;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_improvado_google_ads_campaign
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_improvado].[google_ads_campaign]
WITH (STATE = ON);
GO

-- Security policy for [B_improvado].[google_business_profile_google_my_business_location_attributes]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_improvado_google_business_profile_google_my_business_location_attributes;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_improvado_google_business_profile_google_my_business_location_attributes
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_improvado].[google_business_profile_google_my_business_location_attributes]
WITH (STATE = ON);
GO

-- Security policy for [B_improvado].[google_business_profile_google_my_business_location_insights]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_improvado_google_business_profile_google_my_business_location_insights;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_improvado_google_business_profile_google_my_business_location_insights
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_improvado].[google_business_profile_google_my_business_location_insights]
WITH (STATE = ON);
GO

-- Security policy for [B_improvado].[instagram_organic_page_insights]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_improvado_instagram_organic_page_insights;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_improvado_instagram_organic_page_insights
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_improvado].[instagram_organic_page_insights]
WITH (STATE = ON);
GO

-- Security policy for [B_improvado].[linkedin_organic_page_statistics]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_improvado_linkedin_organic_page_statistics;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_improvado_linkedin_organic_page_statistics
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_improvado].[linkedin_organic_page_statistics]
WITH (STATE = ON);
GO

-- Security policy for [B_improvado].[matomo_general]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_improvado_matomo_general;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_improvado_matomo_general
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_improvado].[matomo_general]
WITH (STATE = ON);
GO

-- Security policy for [B_improvado].[src_improvado_dataflow_run_events]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_improvado_src_improvado_dataflow_run_events;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_improvado_src_improvado_dataflow_run_events
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_improvado].[src_improvado_dataflow_run_events]
WITH (STATE = ON);
GO

-- Security policy for [B_improvado].[src_improvado_order_runs_billing]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_improvado_src_improvado_order_runs_billing;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_improvado_src_improvado_order_runs_billing
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_improvado].[src_improvado_order_runs_billing]
WITH (STATE = ON);
GO

-- Security policy for [B_improvado].[unlock_daily_geostats]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_improvado_unlock_daily_geostats;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_improvado_unlock_daily_geostats
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_improvado].[unlock_daily_geostats]
WITH (STATE = ON);
GO

-- Security policy for [B_improvado].[youtube_organic_channels_all_videos_daily]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_improvado_youtube_organic_channels_all_videos_daily;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_improvado_youtube_organic_channels_all_videos_daily
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_improvado].[youtube_organic_channels_all_videos_daily]
WITH (STATE = ON);
GO

-- Security policy for [B_lawson].[deptcode]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_lawson_deptcode;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_lawson_deptcode
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_lawson].[deptcode]
WITH (STATE = ON);
GO

-- Security policy for [B_lawson].[EDW_HR_Snapshots]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_lawson_EDW_HR_Snapshots;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_lawson_EDW_HR_Snapshots
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_lawson].[EDW_HR_Snapshots]
WITH (STATE = ON);
GO

-- Security policy for [B_lawson].[Employee]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_lawson_Employee;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_lawson_Employee
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_lawson].[Employee]
WITH (STATE = ON);
GO

-- Security policy for [B_lawson].[HR_SNAPSHOTS]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_lawson_HR_SNAPSHOTS;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_lawson_HR_SNAPSHOTS
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_lawson].[HR_SNAPSHOTS]
WITH (STATE = ON);
GO

-- Security policy for [B_lawson].[JobCode]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_lawson_JobCode;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_lawson_JobCode
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_lawson].[JobCode]
WITH (STATE = ON);
GO

-- Security policy for [B_lawson].[PAEmployee]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_lawson_PAEmployee;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_lawson_PAEmployee
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_lawson].[PAEmployee]
WITH (STATE = ON);
GO

-- Security policy for [B_lawson].[SN_CompanyCostCenter]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_lawson_SN_CompanyCostCenter;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_lawson_SN_CompanyCostCenter
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_lawson].[SN_CompanyCostCenter]
WITH (STATE = ON);
GO

-- Security policy for [B_lawson].[SN_REGMKTPLLOC]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_lawson_SN_REGMKTPLLOC;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_lawson_SN_REGMKTPLLOC
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_lawson].[SN_REGMKTPLLOC]
WITH (STATE = ON);
GO

-- Security policy for [B_lawson].[SN_Stacy_RegMktPlLoc]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_lawson_SN_Stacy_RegMktPlLoc;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_lawson_SN_Stacy_RegMktPlLoc
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_lawson].[SN_Stacy_RegMktPlLoc]
WITH (STATE = ON);
GO

-- Security policy for [B_lawson].[Turnover]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_lawson_Turnover;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_lawson_Turnover
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_lawson].[Turnover]
WITH (STATE = ON);
GO

-- Security policy for [B_lawson].[Turnover2]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_lawson_Turnover2;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_lawson_Turnover2
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_lawson].[Turnover2]
WITH (STATE = ON);
GO

-- Security policy for [B_leaseharbor].[LeasedAndOwnedExport]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_leaseharbor_LeasedAndOwnedExport;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_leaseharbor_LeasedAndOwnedExport
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_leaseharbor].[LeasedAndOwnedExport]
WITH (STATE = ON);
GO

-- Security policy for [B_location].[EpicStatusTabHistory]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_location_EpicStatusTabHistory;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_location_EpicStatusTabHistory
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_location].[EpicStatusTabHistory]
WITH (STATE = ON);
GO

-- Security policy for [B_matomo].[LiveLastVisits]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_matomo_LiveLastVisits;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_matomo_LiveLastVisits
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_matomo].[LiveLastVisits]
WITH (STATE = ON);
GO

-- Security policy for [B_matomo].[LiveLastVisits_ActionDetails]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_matomo_LiveLastVisits_ActionDetails;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_matomo_LiveLastVisits_ActionDetails
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_matomo].[LiveLastVisits_ActionDetails]
WITH (STATE = ON);
GO

-- Security policy for [B_matomo].[LiveLastVisits_pluginsIcons]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_matomo_LiveLastVisits_pluginsIcons;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_matomo_LiveLastVisits_pluginsIcons
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_matomo].[LiveLastVisits_pluginsIcons]
WITH (STATE = ON);
GO

-- Security policy for [B_matomo].[LiveLastVisits_test]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_matomo_LiveLastVisits_test;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_matomo_LiveLastVisits_test
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_matomo].[LiveLastVisits_test]
WITH (STATE = ON);
GO

-- Security policy for [B_matomo].[LiveLastVisits_test_ActionDetails]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_matomo_LiveLastVisits_test_ActionDetails;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_matomo_LiveLastVisits_test_ActionDetails
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_matomo].[LiveLastVisits_test_ActionDetails]
WITH (STATE = ON);
GO

-- Security policy for [B_matomo].[LiveLastVisits_test_PluginsIcons]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_matomo_LiveLastVisits_test_PluginsIcons;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_matomo_LiveLastVisits_test_PluginsIcons
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_matomo].[LiveLastVisits_test_PluginsIcons]
WITH (STATE = ON);
GO

-- Security policy for [b_poc].[Employees]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_b_poc_Employees;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_b_poc_Employees
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [b_poc].[Employees]
WITH (STATE = ON);
GO

-- Security policy for [b_poc].[role_members_table]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_b_poc_role_members_table;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_b_poc_role_members_table
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [b_poc].[role_members_table]
WITH (STATE = ON);
GO

-- Security policy for [B_powerbiaudit].[PowerBIAuditLogs]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_powerbiaudit_PowerBIAuditLogs;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_powerbiaudit_PowerBIAuditLogs
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_powerbiaudit].[PowerBIAuditLogs]
WITH (STATE = ON);
GO

-- Security policy for [B_powerbiaudit].[PowerBIAuditLogs_ArtifactAccessRequestInfo_ArtifactAccessRequestInfo_ArtifactOwnerInformation]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_powerbiaudit_PowerBIAuditLogs_ArtifactAccessRequestInfo_ArtifactAccessRequestInfo_ArtifactOwnerInformation;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_powerbiaudit_PowerBIAuditLogs_ArtifactAccessRequestInfo_ArtifactAccessRequestInfo_ArtifactOwnerInformation
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_powerbiaudit].[PowerBIAuditLogs_ArtifactAccessRequestInfo_ArtifactAccessRequestInfo_ArtifactOwnerInformation]
WITH (STATE = ON);
GO

-- Security policy for [B_powerbiaudit].[PowerBIAuditLogs_ArtifactAccessRequestInfo_ArtifactOwnerInformation]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_powerbiaudit_PowerBIAuditLogs_ArtifactAccessRequestInfo_ArtifactOwnerInformation;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_powerbiaudit_PowerBIAuditLogs_ArtifactAccessRequestInfo_ArtifactOwnerInformation
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_powerbiaudit].[PowerBIAuditLogs_ArtifactAccessRequestInfo_ArtifactOwnerInformation]
WITH (STATE = ON);
GO

-- Security policy for [B_powerbiaudit].[PowerBIAuditLogs_SharingInformation]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_powerbiaudit_PowerBIAuditLogs_SharingInformation;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_powerbiaudit_PowerBIAuditLogs_SharingInformation
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_powerbiaudit].[PowerBIAuditLogs_SharingInformation]
WITH (STATE = ON);
GO

-- Security policy for [B_powerbiaudit].[PowerBIAuditLogs1]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_powerbiaudit_PowerBIAuditLogs1;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_powerbiaudit_PowerBIAuditLogs1
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_powerbiaudit].[PowerBIAuditLogs1]
WITH (STATE = ON);
GO

-- Security policy for [B_powerbiaudit].[PowerBIAuditLogs1_ArtifactAccessRequestInfo_ArtifactOwnerInformation]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_powerbiaudit_PowerBIAuditLogs1_ArtifactAccessRequestInfo_ArtifactOwnerInformation;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_powerbiaudit_PowerBIAuditLogs1_ArtifactAccessRequestInfo_ArtifactOwnerInformation
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_powerbiaudit].[PowerBIAuditLogs1_ArtifactAccessRequestInfo_ArtifactOwnerInformation]
WITH (STATE = ON);
GO

-- Security policy for [B_powerbiaudit].[PowerBIAuditLogs1_SharingInformation]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_powerbiaudit_PowerBIAuditLogs1_SharingInformation;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_powerbiaudit_PowerBIAuditLogs1_SharingInformation
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_powerbiaudit].[PowerBIAuditLogs1_SharingInformation]
WITH (STATE = ON);
GO

-- Security policy for [B_pressganey].[CAHPS_SURVEYS]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_pressganey_CAHPS_SURVEYS;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_pressganey_CAHPS_SURVEYS
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_pressganey].[CAHPS_SURVEYS]
WITH (STATE = ON);
GO

-- Security policy for [B_pressganey].[CPT_CODES]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_pressganey_CPT_CODES;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_pressganey_CPT_CODES
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_pressganey].[CPT_CODES]
WITH (STATE = ON);
GO

-- Security policy for [B_rwb].[Measures]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_B_rwb_Measures;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_B_rwb_Measures
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [B_rwb].[Measures]
WITH (STATE = ON);
GO

-- Security policy for [D_mask].[Patients_prd]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_D_mask_Patients_prd;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_D_mask_Patients_prd
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [D_mask].[Patients_prd]
WITH (STATE = ON);
GO

-- Security policy for [D_mask].[Patients_SDM]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_D_mask_Patients_SDM;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_D_mask_Patients_SDM
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [D_mask].[Patients_SDM]
WITH (STATE = ON);
GO

-- Security policy for [D_mask].[PatientsDDM]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_D_mask_PatientsDDM;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_D_mask_PatientsDDM
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [D_mask].[PatientsDDM]
WITH (STATE = ON);
GO

-- Security policy for [D_mask].[PatientTokenized]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_D_mask_PatientTokenized;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_D_mask_PatientTokenized
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [D_mask].[PatientTokenized]
WITH (STATE = ON);
GO

-- Security policy for [dbo].[B_illumicare.Data_all_ardent_2025_07_10]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_dbo_B_illumicare.Data_all_ardent_2025_07_10;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_dbo_B_illumicare.Data_all_ardent_2025_07_10
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [dbo].[B_illumicare.Data_all_ardent_2025_07_10]
WITH (STATE = ON);
GO

-- Security policy for [dbo].[B_illumicare.Data_all_ardent_2025_07_10v2]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_dbo_B_illumicare.Data_all_ardent_2025_07_10v2;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_dbo_B_illumicare.Data_all_ardent_2025_07_10v2
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [dbo].[B_illumicare.Data_all_ardent_2025_07_10v2]
WITH (STATE = ON);
GO

-- Security policy for [dbo].[facebook_ads_ads_creative]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_dbo_facebook_ads_ads_creative;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_dbo_facebook_ads_ads_creative
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [dbo].[facebook_ads_ads_creative]
WITH (STATE = ON);
GO

-- Security policy for [dbo].[google_ads_ads]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_dbo_google_ads_ads;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_dbo_google_ads_ads
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [dbo].[google_ads_ads]
WITH (STATE = ON);
GO

-- Security policy for [dbo].[google_ads_campaign]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_dbo_google_ads_campaign;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_dbo_google_ads_campaign
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [dbo].[google_ads_campaign]
WITH (STATE = ON);
GO

-- Security policy for [dbo].[src_improvado_dataflow_run_events]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_dbo_src_improvado_dataflow_run_events;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_dbo_src_improvado_dataflow_run_events
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [dbo].[src_improvado_dataflow_run_events]
WITH (STATE = ON);
GO

-- Security policy for [dbo].[src_improvado_order_runs_billing]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_dbo_src_improvado_order_runs_billing;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_dbo_src_improvado_order_runs_billing
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [dbo].[src_improvado_order_runs_billing]
WITH (STATE = ON);
GO

-- Security policy for [dbo].[unlock_daily_geostats]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_dbo_unlock_daily_geostats;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_dbo_unlock_daily_geostats
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [dbo].[unlock_daily_geostats]
WITH (STATE = ON);
GO

-- Security policy for [dbo].[ZZ_POS]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_dbo_ZZ_POS;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_dbo_ZZ_POS
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [dbo].[ZZ_POS]
WITH (STATE = ON);
GO

-- Security policy for [dbo].[ZZ_Update Data]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_dbo_ZZ_Update Data;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_dbo_ZZ_Update Data
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [dbo].[ZZ_Update Data]
WITH (STATE = ON);
GO

-- Security policy for [S_clinical].[AvailabilityHours]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_S_clinical_AvailabilityHours;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_S_clinical_AvailabilityHours
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [S_clinical].[AvailabilityHours]
WITH (STATE = ON);
GO

-- Security policy for [S_clinical].[CmsDiabeticBloodPressure]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_S_clinical_CmsDiabeticBloodPressure;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_S_clinical_CmsDiabeticBloodPressure
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [S_clinical].[CmsDiabeticBloodPressure]
WITH (STATE = ON);
GO

-- Security policy for [S_clinical].[FactReferral]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_S_clinical_FactReferral;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_S_clinical_FactReferral
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [S_clinical].[FactReferral]
WITH (STATE = ON);
GO

-- Security policy for [S_common].[EpicLocation]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_S_common_EpicLocation;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_S_common_EpicLocation
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [S_common].[EpicLocation]
WITH (STATE = ON);
GO

-- Security policy for [S_common].[LawsonAddress]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_S_common_LawsonAddress;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_S_common_LawsonAddress
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [S_common].[LawsonAddress]
WITH (STATE = ON);
GO

-- Security policy for [S_common].[LocAddress]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_S_common_LocAddress;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_S_common_LocAddress
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [S_common].[LocAddress]
WITH (STATE = ON);
GO

-- Security policy for [S_common].[Location]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_S_common_Location;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_S_common_Location
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [S_common].[Location]
WITH (STATE = ON);
GO

-- Security policy for [S_common].[LocContact]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_S_common_LocContact;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_S_common_LocContact
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [S_common].[LocContact]
WITH (STATE = ON);
GO

-- Security policy for [S_common].[LocContactDetail]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_S_common_LocContactDetail;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_S_common_LocContactDetail
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [S_common].[LocContactDetail]
WITH (STATE = ON);
GO

-- Security policy for [S_common].[PatientDim]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_S_common_PatientDim;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_S_common_PatientDim
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [S_common].[PatientDim]
WITH (STATE = ON);
GO

-- Security policy for [S_common].[SN_Company]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_S_common_SN_Company;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_S_common_SN_Company
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [S_common].[SN_Company]
WITH (STATE = ON);
GO

-- Security policy for [S_common].[SN_CompanyCostCenter]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_S_common_SN_CompanyCostCenter;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_S_common_SN_CompanyCostCenter
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [S_common].[SN_CompanyCostCenter]
WITH (STATE = ON);
GO

-- Security policy for [S_common].[SN_Location]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_S_common_SN_Location;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_S_common_SN_Location
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [S_common].[SN_Location]
WITH (STATE = ON);
GO

-- Security policy for [S_common].[SN_Location_ProcessCode]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_S_common_SN_Location_ProcessCode;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_S_common_SN_Location_ProcessCode
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [S_common].[SN_Location_ProcessCode]
WITH (STATE = ON);
GO

-- Security policy for [S_common].[SN_Region_Location_ProcessCode]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_S_common_SN_Region_Location_ProcessCode;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_S_common_SN_Region_Location_ProcessCode
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [S_common].[SN_Region_Location_ProcessCode]
WITH (STATE = ON);
GO

-- Security policy for [S_rwb].[Measures]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_S_rwb_Measures;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_S_rwb_Measures
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [S_rwb].[Measures]
WITH (STATE = ON);
GO

-- Security policy for [TERA].[EpicStatusTabHistory]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_TERA_EpicStatusTabHistory;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_TERA_EpicStatusTabHistory
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [TERA].[EpicStatusTabHistory]
WITH (STATE = ON);
GO

-- Security policy for [TERA].[ETL_Job_Log]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_TERA_ETL_Job_Log;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_TERA_ETL_Job_Log
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [TERA].[ETL_Job_Log]
WITH (STATE = ON);
GO

-- Security policy for [TERA].[ETL_Metadata_Log]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_TERA_ETL_Metadata_Log;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_TERA_ETL_Metadata_Log
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [TERA].[ETL_Metadata_Log]
WITH (STATE = ON);
GO

-- Security policy for [TERA].[ETL_Record_Error_Log]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_TERA_ETL_Record_Error_Log;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_TERA_ETL_Record_Error_Log
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [TERA].[ETL_Record_Error_Log]
WITH (STATE = ON);
GO

-- Security policy for [TERA].[ETLPerfTracking]
GO
DROP SECURITY POLICY IF EXISTS sec.sp_TERA_ETLPerfTracking;
GO
-- No CCN column detected in source; using a simplified predicate wrapper:
CREATE FUNCTION sec.fn_allow_any()
RETURNS TABLE WITH SCHEMABINDING AS
RETURN SELECT 1 AS allow_row
WHERE IS_MEMBER('role_Clinician_FullPHI') = 1
   OR IS_MEMBER('role_BI_Reader_Masked') = 1
   OR IS_MEMBER('role_Analyst_Restricted') = 1;
GO
CREATE SECURITY POLICY sec.sp_TERA_ETLPerfTracking
ADD FILTER PREDICATE (SELECT allow_row FROM sec.fn_allow_any())
ON [TERA].[ETLPerfTracking]
WITH (STATE = ON);
GO
