-- =============================================================
-- Dynamic Data Masking (DDM) TEMPLATE SCRIPT
-- NOTE: Replace <datatype> with the actual column datatype.
-- If the column is already masked and you need to change the function,
-- first run: ALTER TABLE [schema].[table] ALTER COLUMN [col] <datatype>;
-- then re-apply MASKED WITH (FUNCTION = '...').
-- =============================================================
GO

-- B_epic.ClarityBed.Bedlabel -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_epic].[ClarityBed]
  ALTER COLUMN [Bedlabel] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_epic.ClarityBed.Telephonenumber -> PII | Direct personal identifier
ALTER TABLE [B_epic].[ClarityBed]
  ALTER COLUMN [Telephonenumber] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- B_epic.ClarityPos.Addressline1 -> PII | Direct personal identifier
ALTER TABLE [B_epic].[ClarityPos]
  ALTER COLUMN [Addressline1] <datatype> MASKED WITH (FUNCTION = 'partial(0,'REDACTED',0)');
GO

-- B_epic.ClarityPos.Addressline2 -> PII | Direct personal identifier
ALTER TABLE [B_epic].[ClarityPos]
  ALTER COLUMN [Addressline2] <datatype> MASKED WITH (FUNCTION = 'partial(0,'REDACTED',0)');
GO

-- B_epic.ClarityPos.Zip -> PII | Direct personal identifier
ALTER TABLE [B_epic].[ClarityPos]
  ALTER COLUMN [Zip] <datatype> MASKED WITH (FUNCTION = 'partial(3,'**',0)');
GO

-- B_epic.ClaritySerAddr.Zip -> PII | Direct personal identifier
ALTER TABLE [B_epic].[ClaritySerAddr]
  ALTER COLUMN [Zip] <datatype> MASKED WITH (FUNCTION = 'partial(3,'**',0)');
GO

-- B_epic.ClaritySerAddr.Phone -> PII | Direct personal identifier
ALTER TABLE [B_epic].[ClaritySerAddr]
  ALTER COLUMN [Phone] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- B_epic.ClaritySerAddr.Email -> PII | Direct personal identifier
ALTER TABLE [B_epic].[ClaritySerAddr]
  ALTER COLUMN [Email] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_epic.ClaritySerAddr.Sharedaddressyn -> PII | Direct personal identifier
ALTER TABLE [B_epic].[ClaritySerAddr]
  ALTER COLUMN [Sharedaddressyn] <datatype> MASKED WITH (FUNCTION = 'partial(0,'REDACTED',0)');
GO

-- B_epic.ClaritySerAddr.Internaladdressyn -> PII | Direct personal identifier
ALTER TABLE [B_epic].[ClaritySerAddr]
  ALTER COLUMN [Internaladdressyn] <datatype> MASKED WITH (FUNCTION = 'partial(0,'REDACTED',0)');
GO

-- B_epic.ClaritySerAddr.Addresschecksum -> PII | Direct personal identifier
ALTER TABLE [B_epic].[ClaritySerAddr]
  ALTER COLUMN [Addresschecksum] <datatype> MASKED WITH (FUNCTION = 'partial(0,'REDACTED',0)');
GO

-- B_epic.FactEncounter.EncounterKey -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_epic].[FactEncounter]
  ALTER COLUMN [EncounterKey] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_epic.FactEncounter.EncounterEpicCsn -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_epic].[FactEncounter]
  ALTER COLUMN [EncounterEpicCsn] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_epic.FactEncounter.PatientKey -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_epic].[FactEncounter]
  ALTER COLUMN [PatientKey] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_epic.FactReferral.Patientkey -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_epic].[FactReferral]
  ALTER COLUMN [Patientkey] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_epic.FactReferral.FirstEncounterKey -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_epic].[FactReferral]
  ALTER COLUMN [FirstEncounterKey] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_epic.FactReferral.FirstEncounterDateKey -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_epic].[FactReferral]
  ALTER COLUMN [FirstEncounterDateKey] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_epic.FactReferral.PrimaryDiagnosisKey -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_epic].[FactReferral]
  ALTER COLUMN [PrimaryDiagnosisKey] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_epic.FactReferral.DiagnosisComboKey -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_epic].[FactReferral]
  ALTER COLUMN [DiagnosisComboKey] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_epic.FactVisit.EncounterKey -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_epic].[FactVisit]
  ALTER COLUMN [EncounterKey] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_epic.FactVisit.PatientDurableKey -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_epic].[FactVisit]
  ALTER COLUMN [PatientDurableKey] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_epic.FactVisit.PatientKey -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_epic].[FactVisit]
  ALTER COLUMN [PatientKey] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_epic.FactVisit.EncounterEpicCSN -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_epic].[FactVisit]
  ALTER COLUMN [EncounterEpicCSN] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_epic.FactVisit.NewPatientStatus -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_epic].[FactVisit]
  ALTER COLUMN [NewPatientStatus] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_epic.FactVisit.PrimaryMRN -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_epic].[FactVisit]
  ALTER COLUMN [PrimaryMRN] <datatype> MASKED WITH (FUNCTION = 'default() or partial(0,'TOKEN-',0)');
GO

-- B_epic.ICDCode.ICDType -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_epic].[ICDCode]
  ALTER COLUMN [ICDType] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_epic.InsuranceClass.ClassName -> PII | Direct personal identifier
ALTER TABLE [B_epic].[InsuranceClass]
  ALTER COLUMN [ClassName] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XX-',4)');
GO

-- B_epic.Patient.MRN -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_epic].[Patient]
  ALTER COLUMN [MRN] <datatype> MASKED WITH (FUNCTION = 'default() or partial(0,'TOKEN-',0)');
GO

-- B_epic.Patient.MRN Type -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_epic].[Patient]
  ALTER COLUMN [MRN Type] <datatype> MASKED WITH (FUNCTION = 'default() or partial(0,'TOKEN-',0)');
GO

-- B_epic.PatientDim.PatientKey -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_epic].[PatientDim]
  ALTER COLUMN [PatientKey] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_epic.PatientDim.PrimaryMrn -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_epic].[PatientDim]
  ALTER COLUMN [PrimaryMrn] <datatype> MASKED WITH (FUNCTION = 'default() or partial(0,'TOKEN-',0)');
GO

-- B_epic.QualityOutcomeFact.Encounterepiccsn -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_epic].[QualityOutcomeFact]
  ALTER COLUMN [Encounterepiccsn] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_epic.QualityOutcomeFact.Encounterkey -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_epic].[QualityOutcomeFact]
  ALTER COLUMN [Encounterkey] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_epic.QualityOutcomeFact.Patientdurablekey -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_epic].[QualityOutcomeFact]
  ALTER COLUMN [Patientdurablekey] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_epic.TeraAvailability.Unavailablersnname -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_epic].[TeraAvailability]
  ALTER COLUMN [Unavailablersnname] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_epic.VTeraAvailability.Unavailablereason -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_epic].[VTeraAvailability]
  ALTER COLUMN [Unavailablereason] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_epic.VTeraAvailability_backup.Unavailablereason -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_epic].[VTeraAvailability_backup]
  ALTER COLUMN [Unavailablereason] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.ACD_Report.Disposition -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[ACD_Report]
  ALTER COLUMN [Disposition] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.ACD_Report.DispositionGroupA -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[ACD_Report]
  ALTER COLUMN [DispositionGroupA] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.ACD_Report.DispositionGroupB -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[ACD_Report]
  ALTER COLUMN [DispositionGroupB] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.ACD_Report.DispositionGroupC -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[ACD_Report]
  ALTER COLUMN [DispositionGroupC] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.ACD_Report.DispositionPath -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[ACD_Report]
  ALTER COLUMN [DispositionPath] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.ACD_Report.QueueCallbackProcessing -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[ACD_Report]
  ALTER COLUMN [QueueCallbackProcessing] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.ACD_Report.CallSurveyResult -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[ACD_Report]
  ALTER COLUMN [CallSurveyResult] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.ACD_Report.Voicemails -> PII | Direct personal identifier
ALTER TABLE [B_five9].[ACD_Report]
  ALTER COLUMN [Voicemails] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_five9.ACD_Report.VoicemailsDeclined -> PII | Direct personal identifier
ALTER TABLE [B_five9].[ACD_Report]
  ALTER COLUMN [VoicemailsDeclined] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_five9.ACD_Report.VoicemailsDeleted -> PII | Direct personal identifier
ALTER TABLE [B_five9].[ACD_Report]
  ALTER COLUMN [VoicemailsDeleted] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_five9.ACD_Report.VoicemailsHandled -> PII | Direct personal identifier
ALTER TABLE [B_five9].[ACD_Report]
  ALTER COLUMN [VoicemailsHandled] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_five9.ACD_Report.VoicemailsReturnedCall -> PII | Direct personal identifier
ALTER TABLE [B_five9].[ACD_Report]
  ALTER COLUMN [VoicemailsReturnedCall] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_five9.ACD_Report.VoicemailsTransferred -> PII | Direct personal identifier
ALTER TABLE [B_five9].[ACD_Report]
  ALTER COLUMN [VoicemailsTransferred] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_five9.ACD_Report.AgentEmail -> PII | Direct personal identifier
ALTER TABLE [B_five9].[ACD_Report]
  ALTER COLUMN [AgentEmail] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_five9.ACD_Report.AgentFirstName -> PII | Direct personal identifier
ALTER TABLE [B_five9].[ACD_Report]
  ALTER COLUMN [AgentFirstName] <datatype> MASKED WITH (FUNCTION = 'partial(1,'***',0)');
GO

-- B_five9.ACD_Report.AgentLastName -> PII | Direct personal identifier
ALTER TABLE [B_five9].[ACD_Report]
  ALTER COLUMN [AgentLastName] <datatype> MASKED WITH (FUNCTION = 'partial(1,'***',0)');
GO

-- B_five9.ACD_Report_new.Disposition -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[ACD_Report_new]
  ALTER COLUMN [Disposition] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.ACD_Report_new.DispositionGroupA -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[ACD_Report_new]
  ALTER COLUMN [DispositionGroupA] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.ACD_Report_new.DispositionGroupB -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[ACD_Report_new]
  ALTER COLUMN [DispositionGroupB] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.ACD_Report_new.DispositionGroupC -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[ACD_Report_new]
  ALTER COLUMN [DispositionGroupC] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.ACD_Report_new.DispositionPath -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[ACD_Report_new]
  ALTER COLUMN [DispositionPath] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.ACD_Report_new.QueueCallbackProcessing -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[ACD_Report_new]
  ALTER COLUMN [QueueCallbackProcessing] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.ACD_Report_new.CallSurveyResult -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[ACD_Report_new]
  ALTER COLUMN [CallSurveyResult] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.ACD_Report_new.Voicemails -> PII | Direct personal identifier
ALTER TABLE [B_five9].[ACD_Report_new]
  ALTER COLUMN [Voicemails] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_five9.ACD_Report_new.VoicemailsDeclined -> PII | Direct personal identifier
ALTER TABLE [B_five9].[ACD_Report_new]
  ALTER COLUMN [VoicemailsDeclined] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_five9.ACD_Report_new.VoicemailsDeleted -> PII | Direct personal identifier
ALTER TABLE [B_five9].[ACD_Report_new]
  ALTER COLUMN [VoicemailsDeleted] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_five9.ACD_Report_new.VoicemailsHandled -> PII | Direct personal identifier
ALTER TABLE [B_five9].[ACD_Report_new]
  ALTER COLUMN [VoicemailsHandled] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_five9.ACD_Report_new.VoicemailsReturnedCall -> PII | Direct personal identifier
ALTER TABLE [B_five9].[ACD_Report_new]
  ALTER COLUMN [VoicemailsReturnedCall] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_five9.ACD_Report_new.VoicemailsTransferred -> PII | Direct personal identifier
ALTER TABLE [B_five9].[ACD_Report_new]
  ALTER COLUMN [VoicemailsTransferred] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_five9.ACD_Report_new.AgentEmail -> PII | Direct personal identifier
ALTER TABLE [B_five9].[ACD_Report_new]
  ALTER COLUMN [AgentEmail] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_five9.ACD_Report_new.AgentFirstName -> PII | Direct personal identifier
ALTER TABLE [B_five9].[ACD_Report_new]
  ALTER COLUMN [AgentFirstName] <datatype> MASKED WITH (FUNCTION = 'partial(1,'***',0)');
GO

-- B_five9.ACD_Report_new.AgentLastName -> PII | Direct personal identifier
ALTER TABLE [B_five9].[ACD_Report_new]
  ALTER COLUMN [AgentLastName] <datatype> MASKED WITH (FUNCTION = 'partial(1,'***',0)');
GO

-- B_five9.Agent_Report.AgentEmail -> PII | Direct personal identifier
ALTER TABLE [B_five9].[Agent_Report]
  ALTER COLUMN [AgentEmail] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_five9.Agent_Report.AgentFirstName -> PII | Direct personal identifier
ALTER TABLE [B_five9].[Agent_Report]
  ALTER COLUMN [AgentFirstName] <datatype> MASKED WITH (FUNCTION = 'partial(1,'***',0)');
GO

-- B_five9.Agent_Report.AgentLastName -> PII | Direct personal identifier
ALTER TABLE [B_five9].[Agent_Report]
  ALTER COLUMN [AgentLastName] <datatype> MASKED WITH (FUNCTION = 'partial(1,'***',0)');
GO

-- B_five9.Agent_Report.AvailableForAll -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[Agent_Report]
  ALTER COLUMN [AvailableForAll] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.Agent_Report.AvailableForCalls -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[Agent_Report]
  ALTER COLUMN [AvailableForCalls] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.Agent_Report.AvailableForVm -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[Agent_Report]
  ALTER COLUMN [AvailableForVm] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.Agent_Report.MediaAvailability -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[Agent_Report]
  ALTER COLUMN [MediaAvailability] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.Agent_Report.SkillAvailability -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[Agent_Report]
  ALTER COLUMN [SkillAvailability] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.Agent_Report.UnavailableForCalls -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[Agent_Report]
  ALTER COLUMN [UnavailableForCalls] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.Agent_Report.UnavailableForVm -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[Agent_Report]
  ALTER COLUMN [UnavailableForVm] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.Agent_Report.OnVoicemailTime -> PII | Direct personal identifier
ALTER TABLE [B_five9].[Agent_Report]
  ALTER COLUMN [OnVoicemailTime] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_five9.Agent_Report.CallSurveyResult -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[Agent_Report]
  ALTER COLUMN [CallSurveyResult] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.Agent_Report.Disposition -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[Agent_Report]
  ALTER COLUMN [Disposition] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.Agent_Report.DispositionGroupA -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[Agent_Report]
  ALTER COLUMN [DispositionGroupA] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.Agent_Report.DispositionGroupB -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[Agent_Report]
  ALTER COLUMN [DispositionGroupB] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.Agent_Report.DispositionGroupC -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[Agent_Report]
  ALTER COLUMN [DispositionGroupC] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.Agent_Report.DispositionPath -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[Agent_Report]
  ALTER COLUMN [DispositionPath] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.Agent_Report.QueueCallbackProcessing -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[Agent_Report]
  ALTER COLUMN [QueueCallbackProcessing] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.Agent_Report.VoicemailHandleTime -> PII | Direct personal identifier
ALTER TABLE [B_five9].[Agent_Report]
  ALTER COLUMN [VoicemailHandleTime] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_five9.Agent_Report.Voicemails -> PII | Direct personal identifier
ALTER TABLE [B_five9].[Agent_Report]
  ALTER COLUMN [Voicemails] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_five9.Agent_Report.VoicemailsDeclined -> PII | Direct personal identifier
ALTER TABLE [B_five9].[Agent_Report]
  ALTER COLUMN [VoicemailsDeclined] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_five9.Agent_Report.VoicemailsDeleted -> PII | Direct personal identifier
ALTER TABLE [B_five9].[Agent_Report]
  ALTER COLUMN [VoicemailsDeleted] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_five9.Agent_Report.VoicemailsHandled -> PII | Direct personal identifier
ALTER TABLE [B_five9].[Agent_Report]
  ALTER COLUMN [VoicemailsHandled] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_five9.Agent_Report.VoicemailsReturnedCall -> PII | Direct personal identifier
ALTER TABLE [B_five9].[Agent_Report]
  ALTER COLUMN [VoicemailsReturnedCall] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_five9.Agent_Report.VoicemailsTransferred -> PII | Direct personal identifier
ALTER TABLE [B_five9].[Agent_Report]
  ALTER COLUMN [VoicemailsTransferred] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_five9.Agent_Report_new.AgentEmail -> PII | Direct personal identifier
ALTER TABLE [B_five9].[Agent_Report_new]
  ALTER COLUMN [AgentEmail] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_five9.Agent_Report_new.AgentFirstName -> PII | Direct personal identifier
ALTER TABLE [B_five9].[Agent_Report_new]
  ALTER COLUMN [AgentFirstName] <datatype> MASKED WITH (FUNCTION = 'partial(1,'***',0)');
GO

-- B_five9.Agent_Report_new.AgentLastName -> PII | Direct personal identifier
ALTER TABLE [B_five9].[Agent_Report_new]
  ALTER COLUMN [AgentLastName] <datatype> MASKED WITH (FUNCTION = 'partial(1,'***',0)');
GO

-- B_five9.Agent_Report_new.AvailableForAll -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[Agent_Report_new]
  ALTER COLUMN [AvailableForAll] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.Agent_Report_new.AvailableForCalls -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[Agent_Report_new]
  ALTER COLUMN [AvailableForCalls] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.Agent_Report_new.AvailableForVm -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[Agent_Report_new]
  ALTER COLUMN [AvailableForVm] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.Agent_Report_new.MediaAvailability -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[Agent_Report_new]
  ALTER COLUMN [MediaAvailability] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.Agent_Report_new.SkillAvailability -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[Agent_Report_new]
  ALTER COLUMN [SkillAvailability] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.Agent_Report_new.UnavailableForCalls -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[Agent_Report_new]
  ALTER COLUMN [UnavailableForCalls] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.Agent_Report_new.UnavailableForVm -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[Agent_Report_new]
  ALTER COLUMN [UnavailableForVm] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.Agent_Report_new.OnVoicemailTime -> PII | Direct personal identifier
ALTER TABLE [B_five9].[Agent_Report_new]
  ALTER COLUMN [OnVoicemailTime] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_five9.Agent_Report_new.CallSurveyResult -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[Agent_Report_new]
  ALTER COLUMN [CallSurveyResult] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.Agent_Report_new.Disposition -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[Agent_Report_new]
  ALTER COLUMN [Disposition] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.Agent_Report_new.DispositionGroupA -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[Agent_Report_new]
  ALTER COLUMN [DispositionGroupA] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.Agent_Report_new.DispositionGroupB -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[Agent_Report_new]
  ALTER COLUMN [DispositionGroupB] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.Agent_Report_new.DispositionGroupC -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[Agent_Report_new]
  ALTER COLUMN [DispositionGroupC] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.Agent_Report_new.DispositionPath -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[Agent_Report_new]
  ALTER COLUMN [DispositionPath] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.Agent_Report_new.QueueCallbackProcessing -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[Agent_Report_new]
  ALTER COLUMN [QueueCallbackProcessing] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.Agent_Report_new.VoicemailHandleTime -> PII | Direct personal identifier
ALTER TABLE [B_five9].[Agent_Report_new]
  ALTER COLUMN [VoicemailHandleTime] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_five9.Agent_Report_new.Voicemails -> PII | Direct personal identifier
ALTER TABLE [B_five9].[Agent_Report_new]
  ALTER COLUMN [Voicemails] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_five9.Agent_Report_new.VoicemailsDeclined -> PII | Direct personal identifier
ALTER TABLE [B_five9].[Agent_Report_new]
  ALTER COLUMN [VoicemailsDeclined] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_five9.Agent_Report_new.VoicemailsDeleted -> PII | Direct personal identifier
ALTER TABLE [B_five9].[Agent_Report_new]
  ALTER COLUMN [VoicemailsDeleted] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_five9.Agent_Report_new.VoicemailsHandled -> PII | Direct personal identifier
ALTER TABLE [B_five9].[Agent_Report_new]
  ALTER COLUMN [VoicemailsHandled] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_five9.Agent_Report_new.VoicemailsReturnedCall -> PII | Direct personal identifier
ALTER TABLE [B_five9].[Agent_Report_new]
  ALTER COLUMN [VoicemailsReturnedCall] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_five9.Agent_Report_new.VoicemailsTransferred -> PII | Direct personal identifier
ALTER TABLE [B_five9].[Agent_Report_new]
  ALTER COLUMN [VoicemailsTransferred] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_five9.AgentState.Full_Name -> PII | Direct personal identifier
ALTER TABLE [B_five9].[AgentState]
  ALTER COLUMN [Full_Name] <datatype> MASKED WITH (FUNCTION = 'partial(1,'***',0)');
GO

-- B_five9.AgentState.Media_Availability -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[AgentState]
  ALTER COLUMN [Media_Availability] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.AgentStatistics.02_Appointment__New_Patient -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[AgentStatistics]
  ALTER COLUMN [02_Appointment__New_Patient] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.AgentStatistics.05_Message__Medication -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[AgentStatistics]
  ALTER COLUMN [05_Message__Medication] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.AgentStatistics.07_Message__Result_Referral_Paperwork_etc -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[AgentStatistics]
  ALTER COLUMN [07_Message__Result_Referral_Paperwork_etc] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.AgentStatistics.09_No_Call__Patient_Disconnect -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[AgentStatistics]
  ALTER COLUMN [09_No_Call__Patient_Disconnect] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.AgentStatistics.Avg_VM_Processing_Time -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[AgentStatistics]
  ALTER COLUMN [Avg_VM_Processing_Time] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.AgentStatistics.Full_Name -> PII | Direct personal identifier
ALTER TABLE [B_five9].[AgentStatistics]
  ALTER COLUMN [Full_Name] <datatype> MASKED WITH (FUNCTION = 'partial(1,'***',0)');
GO

-- B_five9.AgentStatistics.No_Disposition -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[AgentStatistics]
  ALTER COLUMN [No_Disposition] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.AgentStatistics.Processed_Voicemails -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[AgentStatistics]
  ALTER COLUMN [Processed_Voicemails] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_five9.AgentStatistics.Resource_Unavailable -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[AgentStatistics]
  ALTER COLUMN [Resource_Unavailable] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.AgentStatistics.Sent_To_Voicemail -> PII | Direct personal identifier
ALTER TABLE [B_five9].[AgentStatistics]
  ALTER COLUMN [Sent_To_Voicemail] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_five9.AgentStatistics.Voicemail_Dump -> PII | Direct personal identifier
ALTER TABLE [B_five9].[AgentStatistics]
  ALTER COLUMN [Voicemail_Dump] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_five9.AgentStatistics.Voicemail_Processed -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[AgentStatistics]
  ALTER COLUMN [Voicemail_Processed] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_five9.AgentStatistics.Voicemail_Returned -> PII | Direct personal identifier
ALTER TABLE [B_five9].[AgentStatistics]
  ALTER COLUMN [Voicemail_Returned] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_five9.CalllogReport.CallSurveyResult -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[CalllogReport]
  ALTER COLUMN [CallSurveyResult] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.CalllogReport.DialResult -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[CalllogReport]
  ALTER COLUMN [DialResult] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.CalllogReport.Disposition -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[CalllogReport]
  ALTER COLUMN [Disposition] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.CalllogReport.DispositionGroupA -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[CalllogReport]
  ALTER COLUMN [DispositionGroupA] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.CalllogReport.DispositionGroupB -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[CalllogReport]
  ALTER COLUMN [DispositionGroupB] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.CalllogReport.DispositionGroupC -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[CalllogReport]
  ALTER COLUMN [DispositionGroupC] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.CalllogReport.DispositionPath -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[CalllogReport]
  ALTER COLUMN [DispositionPath] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.CalllogReport.QueueCallbackProcessing -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[CalllogReport]
  ALTER COLUMN [QueueCallbackProcessing] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.CalllogReport.Voicemails -> PII | Direct personal identifier
ALTER TABLE [B_five9].[CalllogReport]
  ALTER COLUMN [Voicemails] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_five9.CalllogReport.VoicemailsDeclined -> PII | Direct personal identifier
ALTER TABLE [B_five9].[CalllogReport]
  ALTER COLUMN [VoicemailsDeclined] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_five9.CalllogReport.VoicemailsDeleted -> PII | Direct personal identifier
ALTER TABLE [B_five9].[CalllogReport]
  ALTER COLUMN [VoicemailsDeleted] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_five9.CalllogReport.VoicemailsHandleTime -> PII | Direct personal identifier
ALTER TABLE [B_five9].[CalllogReport]
  ALTER COLUMN [VoicemailsHandleTime] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_five9.CalllogReport.VoicemailsHandled -> PII | Direct personal identifier
ALTER TABLE [B_five9].[CalllogReport]
  ALTER COLUMN [VoicemailsHandled] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_five9.CalllogReport.VoicemailsReturnedCall -> PII | Direct personal identifier
ALTER TABLE [B_five9].[CalllogReport]
  ALTER COLUMN [VoicemailsReturnedCall] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_five9.CalllogReport.VoicemailsTransferred -> PII | Direct personal identifier
ALTER TABLE [B_five9].[CalllogReport]
  ALTER COLUMN [VoicemailsTransferred] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_five9.CalllogReport.AgentEmail -> PII | Direct personal identifier
ALTER TABLE [B_five9].[CalllogReport]
  ALTER COLUMN [AgentEmail] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_five9.CalllogReport.AgentFirstName -> PII | Direct personal identifier
ALTER TABLE [B_five9].[CalllogReport]
  ALTER COLUMN [AgentFirstName] <datatype> MASKED WITH (FUNCTION = 'partial(1,'***',0)');
GO

-- B_five9.CalllogReport.AgentLastName -> PII | Direct personal identifier
ALTER TABLE [B_five9].[CalllogReport]
  ALTER COLUMN [AgentLastName] <datatype> MASKED WITH (FUNCTION = 'partial(1,'***',0)');
GO

-- B_five9.CalllogReport.DestAgentEmail -> PII | Direct personal identifier
ALTER TABLE [B_five9].[CalllogReport]
  ALTER COLUMN [DestAgentEmail] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_five9.CalllogReport.DestAgentFirstName -> PII | Direct personal identifier
ALTER TABLE [B_five9].[CalllogReport]
  ALTER COLUMN [DestAgentFirstName] <datatype> MASKED WITH (FUNCTION = 'partial(1,'***',0)');
GO

-- B_five9.CalllogReport.DestAgentLastName -> PII | Direct personal identifier
ALTER TABLE [B_five9].[CalllogReport]
  ALTER COLUMN [DestAgentLastName] <datatype> MASKED WITH (FUNCTION = 'partial(1,'***',0)');
GO

-- B_five9.CalllogReport.Email -> PII | Direct personal identifier
ALTER TABLE [B_five9].[CalllogReport]
  ALTER COLUMN [Email] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_five9.CalllogReport.FirstName -> PII | Direct personal identifier
ALTER TABLE [B_five9].[CalllogReport]
  ALTER COLUMN [FirstName] <datatype> MASKED WITH (FUNCTION = 'partial(1,'***',0)');
GO

-- B_five9.CalllogReport.LastName -> PII | Direct personal identifier
ALTER TABLE [B_five9].[CalllogReport]
  ALTER COLUMN [LastName] <datatype> MASKED WITH (FUNCTION = 'partial(1,'***',0)');
GO

-- B_five9.CalllogReport.Street -> PII | Direct personal identifier
ALTER TABLE [B_five9].[CalllogReport]
  ALTER COLUMN [Street] <datatype> MASKED WITH (FUNCTION = 'partial(0,'REDACTED',0)');
GO

-- B_five9.CalllogReport.Zip -> PII | Direct personal identifier
ALTER TABLE [B_five9].[CalllogReport]
  ALTER COLUMN [Zip] <datatype> MASKED WITH (FUNCTION = 'partial(3,'**',0)');
GO

-- B_five9.CalllogReport.Studio.patientAni -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[CalllogReport]
  ALTER COLUMN [Studio.patientAni] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.CalllogReport.Studio.patientAuth -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[CalllogReport]
  ALTER COLUMN [Studio.patientAuth] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.CalllogReport.Studio.patientAuthReason -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[CalllogReport]
  ALTER COLUMN [Studio.patientAuthReason] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.CalllogReport.Studio.patientId -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[CalllogReport]
  ALTER COLUMN [Studio.patientId] <datatype> MASKED WITH (FUNCTION = 'default() or partial(0,'TOKEN-',0)');
GO

-- B_five9.CalllogReport.Studio.patientType -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[CalllogReport]
  ALTER COLUMN [Studio.patientType] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.CalllogReport.Studio.transferDisposition -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[CalllogReport]
  ALTER COLUMN [Studio.transferDisposition] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.CalllogReport.Studio.visitType -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[CalllogReport]
  ALTER COLUMN [Studio.visitType] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.Callog_Report_new.CallSurveyResult -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[Callog_Report_new]
  ALTER COLUMN [CallSurveyResult] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.Callog_Report_new.DialResult -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[Callog_Report_new]
  ALTER COLUMN [DialResult] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.Callog_Report_new.Disposition -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[Callog_Report_new]
  ALTER COLUMN [Disposition] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.Callog_Report_new.DispositionGroupA -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[Callog_Report_new]
  ALTER COLUMN [DispositionGroupA] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.Callog_Report_new.DispositionGroupB -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[Callog_Report_new]
  ALTER COLUMN [DispositionGroupB] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.Callog_Report_new.DispositionGroupC -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[Callog_Report_new]
  ALTER COLUMN [DispositionGroupC] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.Callog_Report_new.DispositionPath -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[Callog_Report_new]
  ALTER COLUMN [DispositionPath] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.Callog_Report_new.QueueCallbackProcessing -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[Callog_Report_new]
  ALTER COLUMN [QueueCallbackProcessing] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.Callog_Report_new.Voicemails -> PII | Direct personal identifier
ALTER TABLE [B_five9].[Callog_Report_new]
  ALTER COLUMN [Voicemails] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_five9.Callog_Report_new.VoicemailsDeclined -> PII | Direct personal identifier
ALTER TABLE [B_five9].[Callog_Report_new]
  ALTER COLUMN [VoicemailsDeclined] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_five9.Callog_Report_new.VoicemailsDeleted -> PII | Direct personal identifier
ALTER TABLE [B_five9].[Callog_Report_new]
  ALTER COLUMN [VoicemailsDeleted] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_five9.Callog_Report_new.VoicemailsHandleTime -> PII | Direct personal identifier
ALTER TABLE [B_five9].[Callog_Report_new]
  ALTER COLUMN [VoicemailsHandleTime] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_five9.Callog_Report_new.VoicemailsHandled -> PII | Direct personal identifier
ALTER TABLE [B_five9].[Callog_Report_new]
  ALTER COLUMN [VoicemailsHandled] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_five9.Callog_Report_new.VoicemailsReturnedCall -> PII | Direct personal identifier
ALTER TABLE [B_five9].[Callog_Report_new]
  ALTER COLUMN [VoicemailsReturnedCall] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_five9.Callog_Report_new.VoicemailsTransferred -> PII | Direct personal identifier
ALTER TABLE [B_five9].[Callog_Report_new]
  ALTER COLUMN [VoicemailsTransferred] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_five9.Callog_Report_new.AgentEmail -> PII | Direct personal identifier
ALTER TABLE [B_five9].[Callog_Report_new]
  ALTER COLUMN [AgentEmail] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_five9.Callog_Report_new.AgentFirstName -> PII | Direct personal identifier
ALTER TABLE [B_five9].[Callog_Report_new]
  ALTER COLUMN [AgentFirstName] <datatype> MASKED WITH (FUNCTION = 'partial(1,'***',0)');
GO

-- B_five9.Callog_Report_new.AgentLastName -> PII | Direct personal identifier
ALTER TABLE [B_five9].[Callog_Report_new]
  ALTER COLUMN [AgentLastName] <datatype> MASKED WITH (FUNCTION = 'partial(1,'***',0)');
GO

-- B_five9.Callog_Report_new.DestAgentEmail -> PII | Direct personal identifier
ALTER TABLE [B_five9].[Callog_Report_new]
  ALTER COLUMN [DestAgentEmail] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_five9.Callog_Report_new.DestAgentFirstName -> PII | Direct personal identifier
ALTER TABLE [B_five9].[Callog_Report_new]
  ALTER COLUMN [DestAgentFirstName] <datatype> MASKED WITH (FUNCTION = 'partial(1,'***',0)');
GO

-- B_five9.Callog_Report_new.DestAgentLastName -> PII | Direct personal identifier
ALTER TABLE [B_five9].[Callog_Report_new]
  ALTER COLUMN [DestAgentLastName] <datatype> MASKED WITH (FUNCTION = 'partial(1,'***',0)');
GO

-- B_five9.Callog_Report_new.Email -> PII | Direct personal identifier
ALTER TABLE [B_five9].[Callog_Report_new]
  ALTER COLUMN [Email] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_five9.Callog_Report_new.FirstName -> PII | Direct personal identifier
ALTER TABLE [B_five9].[Callog_Report_new]
  ALTER COLUMN [FirstName] <datatype> MASKED WITH (FUNCTION = 'partial(1,'***',0)');
GO

-- B_five9.Callog_Report_new.LastName -> PII | Direct personal identifier
ALTER TABLE [B_five9].[Callog_Report_new]
  ALTER COLUMN [LastName] <datatype> MASKED WITH (FUNCTION = 'partial(1,'***',0)');
GO

-- B_five9.Callog_Report_new.Street -> PII | Direct personal identifier
ALTER TABLE [B_five9].[Callog_Report_new]
  ALTER COLUMN [Street] <datatype> MASKED WITH (FUNCTION = 'partial(0,'REDACTED',0)');
GO

-- B_five9.Callog_Report_new.Zip -> PII | Direct personal identifier
ALTER TABLE [B_five9].[Callog_Report_new]
  ALTER COLUMN [Zip] <datatype> MASKED WITH (FUNCTION = 'partial(3,'**',0)');
GO

-- B_five9.Callog_Report_new.Studio.patientAni -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[Callog_Report_new]
  ALTER COLUMN [Studio.patientAni] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.Callog_Report_new.Studio.patientAuth -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[Callog_Report_new]
  ALTER COLUMN [Studio.patientAuth] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.Callog_Report_new.Studio.patientAuthReason -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[Callog_Report_new]
  ALTER COLUMN [Studio.patientAuthReason] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.Callog_Report_new.Studio.patientId -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[Callog_Report_new]
  ALTER COLUMN [Studio.patientId] <datatype> MASKED WITH (FUNCTION = 'default() or partial(0,'TOKEN-',0)');
GO

-- B_five9.Callog_Report_new.Studio.patientType -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[Callog_Report_new]
  ALTER COLUMN [Studio.patientType] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.Callog_Report_new.Studio.transferDisposition -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[Callog_Report_new]
  ALTER COLUMN [Studio.transferDisposition] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.Callog_Report_new.Studio.visitType -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[Callog_Report_new]
  ALTER COLUMN [Studio.visitType] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.InboundCamoaignStatistics.02_Appointment__New_Patient -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[InboundCamoaignStatistics]
  ALTER COLUMN [02_Appointment__New_Patient] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.InboundCamoaignStatistics.05_Message__Medication -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[InboundCamoaignStatistics]
  ALTER COLUMN [05_Message__Medication] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.InboundCamoaignStatistics.07_Message__Result_Referral_Paperwork_etc -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[InboundCamoaignStatistics]
  ALTER COLUMN [07_Message__Result_Referral_Paperwork_etc] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.InboundCamoaignStatistics.09_No_Call__Patient_Disconnect -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[InboundCamoaignStatistics]
  ALTER COLUMN [09_No_Call__Patient_Disconnect] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.InboundCamoaignStatistics.No_Disposition -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[InboundCamoaignStatistics]
  ALTER COLUMN [No_Disposition] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.InboundCamoaignStatistics.Resource_Unavailable -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[InboundCamoaignStatistics]
  ALTER COLUMN [Resource_Unavailable] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.InboundCamoaignStatistics.Sent_To_Voicemail -> PII | Direct personal identifier
ALTER TABLE [B_five9].[InboundCamoaignStatistics]
  ALTER COLUMN [Sent_To_Voicemail] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_five9.InboundCamoaignStatistics.Voicemail_Dump -> PII | Direct personal identifier
ALTER TABLE [B_five9].[InboundCamoaignStatistics]
  ALTER COLUMN [Voicemail_Dump] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_five9.InboundCamoaignStatistics.Voicemail_Processed -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[InboundCamoaignStatistics]
  ALTER COLUMN [Voicemail_Processed] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_five9.InboundCamoaignStatistics.Voicemail_Returned -> PII | Direct personal identifier
ALTER TABLE [B_five9].[InboundCamoaignStatistics]
  ALTER COLUMN [Voicemail_Returned] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_five9.OutboundCampaignStatistics.02_Appointment__New_Patient -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[OutboundCampaignStatistics]
  ALTER COLUMN [02_Appointment__New_Patient] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.OutboundCampaignStatistics.05_Message__Medication -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[OutboundCampaignStatistics]
  ALTER COLUMN [05_Message__Medication] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.OutboundCampaignStatistics.07_Message__Result_Referral_Paperwork_etc -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[OutboundCampaignStatistics]
  ALTER COLUMN [07_Message__Result_Referral_Paperwork_etc] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.OutboundCampaignStatistics.09_No_Call__Patient_Disconnect -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[OutboundCampaignStatistics]
  ALTER COLUMN [09_No_Call__Patient_Disconnect] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.OutboundCampaignStatistics.No_Disposition -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[OutboundCampaignStatistics]
  ALTER COLUMN [No_Disposition] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.OutboundCampaignStatistics.Resource_Unavailable -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[OutboundCampaignStatistics]
  ALTER COLUMN [Resource_Unavailable] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_five9.OutboundCampaignStatistics.Sent_To_Voicemail -> PII | Direct personal identifier
ALTER TABLE [B_five9].[OutboundCampaignStatistics]
  ALTER COLUMN [Sent_To_Voicemail] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_five9.OutboundCampaignStatistics.Voicemail_Dump -> PII | Direct personal identifier
ALTER TABLE [B_five9].[OutboundCampaignStatistics]
  ALTER COLUMN [Voicemail_Dump] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_five9.OutboundCampaignStatistics.Voicemail_Processed -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_five9].[OutboundCampaignStatistics]
  ALTER COLUMN [Voicemail_Processed] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_five9.OutboundCampaignStatistics.Voicemail_Returned -> PII | Direct personal identifier
ALTER TABLE [B_five9].[OutboundCampaignStatistics]
  ALTER COLUMN [Voicemail_Returned] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_iam.srcAD.givenname -> PII | Direct personal identifier
ALTER TABLE [B_iam].[srcAD]
  ALTER COLUMN [givenname] <datatype> MASKED WITH (FUNCTION = 'partial(1,'***',0)');
GO

-- B_iam.srcAD.surname -> PII | Direct personal identifier
ALTER TABLE [B_iam].[srcAD]
  ALTER COLUMN [surname] <datatype> MASKED WITH (FUNCTION = 'partial(1,'***',0)');
GO

-- B_iam.srcAD.msExchHideFromAddressLists -> PII | Direct personal identifier
ALTER TABLE [B_iam].[srcAD]
  ALTER COLUMN [msExchHideFromAddressLists] <datatype> MASKED WITH (FUNCTION = 'partial(0,'REDACTED',0)');
GO

-- B_iam.srcADgroups.managedObjects -> PII | Direct personal identifier
ALTER TABLE [B_iam].[srcADgroups]
  ALTER COLUMN [managedObjects] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_iam.srcADgroups.member -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_iam].[srcADgroups]
  ALTER COLUMN [member] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_iam.srcAya.SSN -> PII | Direct personal identifier
ALTER TABLE [B_iam].[srcAya]
  ALTER COLUMN [SSN] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XX-',4)');
GO

-- B_iam.srcAya.FirstName -> PII | Direct personal identifier
ALTER TABLE [B_iam].[srcAya]
  ALTER COLUMN [FirstName] <datatype> MASKED WITH (FUNCTION = 'partial(1,'***',0)');
GO

-- B_iam.srcAya.LastName -> PII | Direct personal identifier
ALTER TABLE [B_iam].[srcAya]
  ALTER COLUMN [LastName] <datatype> MASKED WITH (FUNCTION = 'partial(1,'***',0)');
GO

-- B_iam.srcAya.Home Address -> PII | Direct personal identifier
ALTER TABLE [B_iam].[srcAya]
  ALTER COLUMN [Home Address] <datatype> MASKED WITH (FUNCTION = 'partial(0,'REDACTED',0)');
GO

-- B_iam.srcAya.Zip -> PII | Direct personal identifier
ALTER TABLE [B_iam].[srcAya]
  ALTER COLUMN [Zip] <datatype> MASKED WITH (FUNCTION = 'partial(3,'**',0)');
GO

-- B_iam.srcAya.Email -> PII | Direct personal identifier
ALTER TABLE [B_iam].[srcAya]
  ALTER COLUMN [Email] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_iam.srcAya.Phone -> PII | Direct personal identifier
ALTER TABLE [B_iam].[srcAya]
  ALTER COLUMN [Phone] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- B_iam.srcAya.DOB -> PII | Direct personal identifier
ALTER TABLE [B_iam].[srcAya]
  ALTER COLUMN [DOB] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_iam.srcAya.Manager_Email -> PII | Direct personal identifier
ALTER TABLE [B_iam].[srcAya]
  ALTER COLUMN [Manager_Email] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_iam.srcAya.Process_Level -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_iam].[srcAya]
  ALTER COLUMN [Process_Level] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_iam.srcEnsemble.Date_Of_Birth -> PII | Date of birth is a direct identifier
ALTER TABLE [B_iam].[srcEnsemble]
  ALTER COLUMN [Date_Of_Birth] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_iam.srcEnsemble.Work_Email -> PII | Direct personal identifier
ALTER TABLE [B_iam].[srcEnsemble]
  ALTER COLUMN [Work_Email] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_iam.srcEnsemble.Work_Address1 -> PII | Direct personal identifier
ALTER TABLE [B_iam].[srcEnsemble]
  ALTER COLUMN [Work_Address1] <datatype> MASKED WITH (FUNCTION = 'partial(0,'REDACTED',0)');
GO

-- B_iam.srcEnsemble.Work_Address2 -> PII | Direct personal identifier
ALTER TABLE [B_iam].[srcEnsemble]
  ALTER COLUMN [Work_Address2] <datatype> MASKED WITH (FUNCTION = 'partial(0,'REDACTED',0)');
GO

-- B_iam.srcEnsemble.Manager-Level_01_Email -> PII | Direct personal identifier
ALTER TABLE [B_iam].[srcEnsemble]
  ALTER COLUMN [Manager-Level_01_Email] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_iam.srcEnsemble.Home_Address1 -> PII | Direct personal identifier
ALTER TABLE [B_iam].[srcEnsemble]
  ALTER COLUMN [Home_Address1] <datatype> MASKED WITH (FUNCTION = 'partial(0,'REDACTED',0)');
GO

-- B_iam.srcEnsemble.Home_Address2 -> PII | Direct personal identifier
ALTER TABLE [B_iam].[srcEnsemble]
  ALTER COLUMN [Home_Address2] <datatype> MASKED WITH (FUNCTION = 'partial(0,'REDACTED',0)');
GO

-- B_iam.srcEnsemble.Last4SSN -> PII | Direct personal identifier
ALTER TABLE [B_iam].[srcEnsemble]
  ALTER COLUMN [Last4SSN] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XX-',4)');
GO

-- B_iam.srcEpicAccounts.Available Linkable Templates 1110 -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_iam].[srcEpicAccounts]
  ALTER COLUMN [Available Linkable Templates 1110] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_iam.srcLawson.FULL_NAME -> PII | Direct personal identifier
ALTER TABLE [B_iam].[srcLawson]
  ALTER COLUMN [FULL_NAME] <datatype> MASKED WITH (FUNCTION = 'partial(1,'***',0)');
GO

-- B_iam.srcLawson.PROCESS_LEVEL -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_iam].[srcLawson]
  ALTER COLUMN [PROCESS_LEVEL] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_iam.srcLawson.ZIP -> PII | Direct personal identifier
ALTER TABLE [B_iam].[srcLawson]
  ALTER COLUMN [ZIP] <datatype> MASKED WITH (FUNCTION = 'partial(3,'**',0)');
GO

-- B_iam.srcLawson.DOB -> PII | Direct personal identifier
ALTER TABLE [B_iam].[srcLawson]
  ALTER COLUMN [DOB] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_iam.srcLawson.EMAIL_ADDRESS -> PII | Direct personal identifier
ALTER TABLE [B_iam].[srcLawson]
  ALTER COLUMN [EMAIL_ADDRESS] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_iam.srcLawson.MANAGER_EMAIL -> PII | Direct personal identifier
ALTER TABLE [B_iam].[srcLawson]
  ALTER COLUMN [MANAGER_EMAIL] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_iam.srcLawson.HOME_ZIP -> PII | Direct personal identifier
ALTER TABLE [B_iam].[srcLawson]
  ALTER COLUMN [HOME_ZIP] <datatype> MASKED WITH (FUNCTION = 'partial(3,'**',0)');
GO

-- B_iam.srcLawsonPositions.PROCESS_LEVEL -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_iam].[srcLawsonPositions]
  ALTER COLUMN [PROCESS_LEVEL] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_iam.srcLawsonPositions.PROCESS_LEVEL_DESCRIPTION -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_iam].[srcLawsonPositions]
  ALTER COLUMN [PROCESS_LEVEL_DESCRIPTION] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_iam.srcLawsonPositions.ProcessLevel Department -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_iam].[srcLawsonPositions]
  ALTER COLUMN [ProcessLevel Department] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_iam.srcManagers.Work_Email -> PII | Direct personal identifier
ALTER TABLE [B_iam].[srcManagers]
  ALTER COLUMN [Work_Email] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_iam.srcNorthcampus.SSN -> PII | Direct personal identifier
ALTER TABLE [B_iam].[srcNorthcampus]
  ALTER COLUMN [SSN] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XX-',4)');
GO

-- B_iam.srcNorthcampus.FirstName -> PII | Direct personal identifier
ALTER TABLE [B_iam].[srcNorthcampus]
  ALTER COLUMN [FirstName] <datatype> MASKED WITH (FUNCTION = 'partial(1,'***',0)');
GO

-- B_iam.srcNorthcampus.LastName -> PII | Direct personal identifier
ALTER TABLE [B_iam].[srcNorthcampus]
  ALTER COLUMN [LastName] <datatype> MASKED WITH (FUNCTION = 'partial(1,'***',0)');
GO

-- B_iam.srcNorthcampus.HomeAddress -> PII | Direct personal identifier
ALTER TABLE [B_iam].[srcNorthcampus]
  ALTER COLUMN [HomeAddress] <datatype> MASKED WITH (FUNCTION = 'partial(0,'REDACTED',0)');
GO

-- B_iam.srcNorthcampus.ZIp -> PII | Direct personal identifier
ALTER TABLE [B_iam].[srcNorthcampus]
  ALTER COLUMN [ZIp] <datatype> MASKED WITH (FUNCTION = 'partial(3,'**',0)');
GO

-- B_iam.srcNorthcampus.Dob -> PII | Direct personal identifier
ALTER TABLE [B_iam].[srcNorthcampus]
  ALTER COLUMN [Dob] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_iam.srcNorthcampus.Email -> PII | Direct personal identifier
ALTER TABLE [B_iam].[srcNorthcampus]
  ALTER COLUMN [Email] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_iam.srcNorthcampus.Phone -> PII | Direct personal identifier
ALTER TABLE [B_iam].[srcNorthcampus]
  ALTER COLUMN [Phone] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- B_iam.srcNorthcampus.Manager_Email -> PII | Direct personal identifier
ALTER TABLE [B_iam].[srcNorthcampus]
  ALTER COLUMN [Manager_Email] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_iam.srcNorthcampus.Manager_Phone -> PII | Direct personal identifier
ALTER TABLE [B_iam].[srcNorthcampus]
  ALTER COLUMN [Manager_Phone] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- B_iam.srcSodexo.EMPL_EMAIL_ADDR -> PII | Direct personal identifier
ALTER TABLE [B_iam].[srcSodexo]
  ALTER COLUMN [EMPL_EMAIL_ADDR] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_iam.srcSodexo.MGR_EMAIL_ADDR -> PII | Direct personal identifier
ALTER TABLE [B_iam].[srcSodexo]
  ALTER COLUMN [MGR_EMAIL_ADDR] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_iam.srcSodexo.EMPL_SSN -> PII | Direct personal identifier
ALTER TABLE [B_iam].[srcSodexo]
  ALTER COLUMN [EMPL_SSN] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XX-',4)');
GO

-- B_iam.srcSodexo.EMPL_ZIP_CD -> PII | Direct personal identifier
ALTER TABLE [B_iam].[srcSodexo]
  ALTER COLUMN [EMPL_ZIP_CD] <datatype> MASKED WITH (FUNCTION = 'partial(3,'**',0)');
GO

-- B_iam.srcSymplr.Date_Of_Birth -> PII | Date of birth is a direct identifier
ALTER TABLE [B_iam].[srcSymplr]
  ALTER COLUMN [Date_Of_Birth] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_iam.srcSymplr.SSN -> PII | Direct personal identifier
ALTER TABLE [B_iam].[srcSymplr]
  ALTER COLUMN [SSN] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XX-',4)');
GO

-- B_iam.srcSymplr.Primary_Practice_AddressLine1 -> PII | Direct personal identifier
ALTER TABLE [B_iam].[srcSymplr]
  ALTER COLUMN [Primary_Practice_AddressLine1] <datatype> MASKED WITH (FUNCTION = 'partial(0,'REDACTED',0)');
GO

-- B_iam.srcSymplr.Primary_Practice_AddressLine2 -> PII | Direct personal identifier
ALTER TABLE [B_iam].[srcSymplr]
  ALTER COLUMN [Primary_Practice_AddressLine2] <datatype> MASKED WITH (FUNCTION = 'partial(0,'REDACTED',0)');
GO

-- B_iam.srcSymplr.Primary_Practice_ZipCode -> PII | Direct personal identifier
ALTER TABLE [B_iam].[srcSymplr]
  ALTER COLUMN [Primary_Practice_ZipCode] <datatype> MASKED WITH (FUNCTION = 'partial(3,'**',0)');
GO

-- B_iam.srcSymplr.Primary_Practice_Phone -> PII | Direct personal identifier
ALTER TABLE [B_iam].[srcSymplr]
  ALTER COLUMN [Primary_Practice_Phone] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- B_iam.srcSymplr.Primary_Practice_Email -> PII | Direct personal identifier
ALTER TABLE [B_iam].[srcSymplr]
  ALTER COLUMN [Primary_Practice_Email] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_iam.srcSymplr.Cell_Phone -> PII | Direct personal identifier
ALTER TABLE [B_iam].[srcSymplr]
  ALTER COLUMN [Cell_Phone] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- B_iam.srcSymplr.State_License_Number -> PII | Direct personal identifier
ALTER TABLE [B_iam].[srcSymplr]
  ALTER COLUMN [State_License_Number] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_iam.srcSymplr.Medicare_Number -> PII | Direct personal identifier
ALTER TABLE [B_iam].[srcSymplr]
  ALTER COLUMN [Medicare_Number] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_iam.srcSymplr.Medicaid_Number -> PII | Direct personal identifier
ALTER TABLE [B_iam].[srcSymplr]
  ALTER COLUMN [Medicaid_Number] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_icims.Icims.Department   Process Level -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_icims].[Icims]
  ALTER COLUMN [Department   Process Level] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_icims.Icims.Hiring Manager   Primary Email Address -> PII | Direct personal identifier
ALTER TABLE [B_icims].[Icims]
  ALTER COLUMN [Hiring Manager   Primary Email Address] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_icims.Icims.Laborlytics Approval ID -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_icims].[Icims]
  ALTER COLUMN [Laborlytics Approval ID] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_icims.Icims.Recruiter   Primary Email Address -> PII | Direct personal identifier
ALTER TABLE [B_icims].[Icims]
  ALTER COLUMN [Recruiter   Primary Email Address] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_icims.Icims.Secondary Hiring Manager   Primary Email -> PII | Direct personal identifier
ALTER TABLE [B_icims].[Icims]
  ALTER COLUMN [Secondary Hiring Manager   Primary Email] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_icims.Icims.Preboarder   Primary Email -> PII | Direct personal identifier
ALTER TABLE [B_icims].[Icims]
  ALTER COLUMN [Preboarder   Primary Email] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_icims.Icims.Secondary Recruiter   Primary Email -> PII | Direct personal identifier
ALTER TABLE [B_icims].[Icims]
  ALTER COLUMN [Secondary Recruiter   Primary Email] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_icims.Icims.# Currently in Bin Dispositioned Candidates -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_icims].[Icims]
  ALTER COLUMN [# Currently in Bin Dispositioned Candidates] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_icims.Icims.# Ever in Bin Dispositioned Candidates -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_icims].[Icims]
  ALTER COLUMN [# Ever in Bin Dispositioned Candidates] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_improvado.callrail_calls.agent_email -> PII | Direct personal identifier
ALTER TABLE [B_improvado].[callrail_calls]
  ALTER COLUMN [agent_email] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_improvado.callrail_calls.business_phone_number -> PII | Direct personal identifier
ALTER TABLE [B_improvado].[callrail_calls]
  ALTER COLUMN [business_phone_number] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- B_improvado.callrail_calls.customer_phone_number -> PII | Direct personal identifier
ALTER TABLE [B_improvado].[callrail_calls]
  ALTER COLUMN [customer_phone_number] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- B_improvado.callrail_calls.formatted_business_phone_number -> PII | Direct personal identifier
ALTER TABLE [B_improvado].[callrail_calls]
  ALTER COLUMN [formatted_business_phone_number] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- B_improvado.callrail_calls.formatted_customer_name_or_phone_number -> PII | Direct personal identifier
ALTER TABLE [B_improvado].[callrail_calls]
  ALTER COLUMN [formatted_customer_name_or_phone_number] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- B_improvado.callrail_calls.formatted_customer_phone_number -> PII | Direct personal identifier
ALTER TABLE [B_improvado].[callrail_calls]
  ALTER COLUMN [formatted_customer_phone_number] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- B_improvado.callrail_calls.formatted_tracking_phone_number -> PII | Direct personal identifier
ALTER TABLE [B_improvado].[callrail_calls]
  ALTER COLUMN [formatted_tracking_phone_number] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- B_improvado.callrail_calls.tracking_phone_number -> PII | Direct personal identifier
ALTER TABLE [B_improvado].[callrail_calls]
  ALTER COLUMN [tracking_phone_number] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- B_improvado.callrail_calls.voicemail -> PII | Direct personal identifier
ALTER TABLE [B_improvado].[callrail_calls]
  ALTER COLUMN [voicemail] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_improvado.dim_ai_notebooks_meta.cell_id -> PII | Direct personal identifier
ALTER TABLE [B_improvado].[dim_ai_notebooks_meta]
  ALTER COLUMN [cell_id] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- B_improvado.dim_ai_notebooks_meta.user_email -> PII | Direct personal identifier
ALTER TABLE [B_improvado].[dim_ai_notebooks_meta]
  ALTER COLUMN [user_email] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_improvado.facebook_ads_ads_creative.caption -> PII | Direct personal identifier
ALTER TABLE [B_improvado].[facebook_ads_ads_creative]
  ALTER COLUMN [caption] <datatype> MASKED WITH (FUNCTION = 'partial(0,'REDACTED',0)');
GO

-- B_improvado.facebook_ads_ads_creative.catalog_mobile_add_to_cart -> PII | Direct personal identifier
ALTER TABLE [B_improvado].[facebook_ads_ads_creative]
  ALTER COLUMN [catalog_mobile_add_to_cart] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- B_improvado.facebook_ads_ads_creative.catalog_mobile_add_to_cart_value -> PII | Direct personal identifier
ALTER TABLE [B_improvado].[facebook_ads_ads_creative]
  ALTER COLUMN [catalog_mobile_add_to_cart_value] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- B_improvado.facebook_ads_ads_creative.catalog_mobile_content_view -> PII | Direct personal identifier
ALTER TABLE [B_improvado].[facebook_ads_ads_creative]
  ALTER COLUMN [catalog_mobile_content_view] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- B_improvado.facebook_ads_ads_creative.catalog_mobile_content_view_value -> PII | Direct personal identifier
ALTER TABLE [B_improvado].[facebook_ads_ads_creative]
  ALTER COLUMN [catalog_mobile_content_view_value] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- B_improvado.facebook_ads_ads_creative.catalog_mobile_purchase -> PII | Direct personal identifier
ALTER TABLE [B_improvado].[facebook_ads_ads_creative]
  ALTER COLUMN [catalog_mobile_purchase] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- B_improvado.facebook_ads_ads_creative.catalog_mobile_purchase_value -> PII | Direct personal identifier
ALTER TABLE [B_improvado].[facebook_ads_ads_creative]
  ALTER COLUMN [catalog_mobile_purchase_value] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- B_improvado.facebook_ads_ads_creative.fb_mobile_add_payment_info -> PII | Direct personal identifier
ALTER TABLE [B_improvado].[facebook_ads_ads_creative]
  ALTER COLUMN [fb_mobile_add_payment_info] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- B_improvado.facebook_ads_ads_creative.fb_mobile_complete_registration -> PII | Direct personal identifier
ALTER TABLE [B_improvado].[facebook_ads_ads_creative]
  ALTER COLUMN [fb_mobile_complete_registration] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- B_improvado.facebook_ads_ads_creative.fb_mobile_content_view -> PII | Direct personal identifier
ALTER TABLE [B_improvado].[facebook_ads_ads_creative]
  ALTER COLUMN [fb_mobile_content_view] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- B_improvado.facebook_ads_ads_creative.fb_mobile_purchase -> PII | Direct personal identifier
ALTER TABLE [B_improvado].[facebook_ads_ads_creative]
  ALTER COLUMN [fb_mobile_purchase] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- B_improvado.facebook_ads_ads_creative.mobile_app_install -> PII | Direct personal identifier
ALTER TABLE [B_improvado].[facebook_ads_ads_creative]
  ALTER COLUMN [mobile_app_install] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- B_improvado.facebook_ads_ads_creative.mobile_click_through -> PII | Direct personal identifier
ALTER TABLE [B_improvado].[facebook_ads_ads_creative]
  ALTER COLUMN [mobile_click_through] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- B_improvado.facebook_ads_ads_creative.mobile_view_through -> PII | Direct personal identifier
ALTER TABLE [B_improvado].[facebook_ads_ads_creative]
  ALTER COLUMN [mobile_view_through] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- B_improvado.facebook_ads_ads_creative.schedule_mobile_app -> PII | Direct personal identifier
ALTER TABLE [B_improvado].[facebook_ads_ads_creative]
  ALTER COLUMN [schedule_mobile_app] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- B_improvado.facebook_ads_ads_creative.start_trial_mobile_app -> PII | Direct personal identifier
ALTER TABLE [B_improvado].[facebook_ads_ads_creative]
  ALTER COLUMN [start_trial_mobile_app] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- B_improvado.google_ads_ads.ad_group_ad_label_ids -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_improvado].[google_ads_ads]
  ALTER COLUMN [ad_group_ad_label_ids] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_improvado.google_ads_ads.ad_group_ad_labels -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_improvado].[google_ads_ads]
  ALTER COLUMN [ad_group_ad_labels] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_improvado.google_ads_ads.ad_group_labels -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_improvado].[google_ads_ads]
  ALTER COLUMN [ad_group_labels] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_improvado.google_ads_ads.ad_mobile_final_url -> PII | Direct personal identifier
ALTER TABLE [B_improvado].[google_ads_ads]
  ALTER COLUMN [ad_mobile_final_url] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- B_improvado.google_ads_ads.campaign_label_ids -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_improvado].[google_ads_ads]
  ALTER COLUMN [campaign_label_ids] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_improvado.google_ads_ads.campaign_label_names -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_improvado].[google_ads_ads]
  ALTER COLUMN [campaign_label_names] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_improvado.google_ads_campaign.campaign_label_ids -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_improvado].[google_ads_campaign]
  ALTER COLUMN [campaign_label_ids] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_improvado.google_ads_campaign.campaign_labels -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_improvado].[google_ads_campaign]
  ALTER COLUMN [campaign_labels] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_improvado.google_business_profile_google_my_business_location_attributes.phone_numbers -> PII | Direct personal identifier
ALTER TABLE [B_improvado].[google_business_profile_google_my_business_location_attributes]
  ALTER COLUMN [phone_numbers] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- B_improvado.google_business_profile_google_my_business_location_attributes.storefront_address -> PII | Direct personal identifier
ALTER TABLE [B_improvado].[google_business_profile_google_my_business_location_attributes]
  ALTER COLUMN [storefront_address] <datatype> MASKED WITH (FUNCTION = 'partial(0,'REDACTED',0)');
GO

-- B_improvado.google_business_profile_google_my_business_location_insights.address_line -> PII | Direct personal identifier
ALTER TABLE [B_improvado].[google_business_profile_google_my_business_location_insights]
  ALTER COLUMN [address_line] <datatype> MASKED WITH (FUNCTION = 'partial(0,'REDACTED',0)');
GO

-- B_improvado.google_business_profile_google_my_business_location_insights.business_impressions_mobile_maps -> PII | Direct personal identifier
ALTER TABLE [B_improvado].[google_business_profile_google_my_business_location_insights]
  ALTER COLUMN [business_impressions_mobile_maps] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- B_improvado.google_business_profile_google_my_business_location_insights.business_impressions_mobile_search -> PII | Direct personal identifier
ALTER TABLE [B_improvado].[google_business_profile_google_my_business_location_insights]
  ALTER COLUMN [business_impressions_mobile_search] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- B_improvado.google_business_profile_google_my_business_location_insights.labels -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_improvado].[google_business_profile_google_my_business_location_insights]
  ALTER COLUMN [labels] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_improvado.google_business_profile_google_my_business_location_insights.location_and_address -> PII | Direct personal identifier
ALTER TABLE [B_improvado].[google_business_profile_google_my_business_location_insights]
  ALTER COLUMN [location_and_address] <datatype> MASKED WITH (FUNCTION = 'partial(0,'REDACTED',0)');
GO

-- B_improvado.instagram_organic_page_insights.email_contacts -> PII | Direct personal identifier
ALTER TABLE [B_improvado].[instagram_organic_page_insights]
  ALTER COLUMN [email_contacts] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_improvado.instagram_organic_page_insights.phone_call_clicks -> PII | Direct personal identifier
ALTER TABLE [B_improvado].[instagram_organic_page_insights]
  ALTER COLUMN [phone_call_clicks] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- B_improvado.linkedin_organic_page_statistics.all_mobile_page_views -> PII | Direct personal identifier
ALTER TABLE [B_improvado].[linkedin_organic_page_statistics]
  ALTER COLUMN [all_mobile_page_views] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- B_improvado.linkedin_organic_page_statistics.all_mobile_page_views_unique -> PII | Direct personal identifier
ALTER TABLE [B_improvado].[linkedin_organic_page_statistics]
  ALTER COLUMN [all_mobile_page_views_unique] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- B_improvado.linkedin_organic_page_statistics.mobile_about_page_views -> PII | Direct personal identifier
ALTER TABLE [B_improvado].[linkedin_organic_page_statistics]
  ALTER COLUMN [mobile_about_page_views] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- B_improvado.linkedin_organic_page_statistics.mobile_about_page_views_unique -> PII | Direct personal identifier
ALTER TABLE [B_improvado].[linkedin_organic_page_statistics]
  ALTER COLUMN [mobile_about_page_views_unique] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- B_improvado.linkedin_organic_page_statistics.mobile_careers_page_employees_clicks -> PII | Direct personal identifier
ALTER TABLE [B_improvado].[linkedin_organic_page_statistics]
  ALTER COLUMN [mobile_careers_page_employees_clicks] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- B_improvado.linkedin_organic_page_statistics.mobile_careers_page_jobs_promo_clicks -> PII | Direct personal identifier
ALTER TABLE [B_improvado].[linkedin_organic_page_statistics]
  ALTER COLUMN [mobile_careers_page_jobs_promo_clicks] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- B_improvado.linkedin_organic_page_statistics.mobile_careers_page_promo_links_clicks -> PII | Direct personal identifier
ALTER TABLE [B_improvado].[linkedin_organic_page_statistics]
  ALTER COLUMN [mobile_careers_page_promo_links_clicks] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- B_improvado.linkedin_organic_page_statistics.mobile_careers_page_views -> PII | Direct personal identifier
ALTER TABLE [B_improvado].[linkedin_organic_page_statistics]
  ALTER COLUMN [mobile_careers_page_views] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- B_improvado.linkedin_organic_page_statistics.mobile_careers_page_views_unique -> PII | Direct personal identifier
ALTER TABLE [B_improvado].[linkedin_organic_page_statistics]
  ALTER COLUMN [mobile_careers_page_views_unique] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- B_improvado.linkedin_organic_page_statistics.mobile_insights_page_views -> PII | Direct personal identifier
ALTER TABLE [B_improvado].[linkedin_organic_page_statistics]
  ALTER COLUMN [mobile_insights_page_views] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- B_improvado.linkedin_organic_page_statistics.mobile_insights_page_views_unique -> PII | Direct personal identifier
ALTER TABLE [B_improvado].[linkedin_organic_page_statistics]
  ALTER COLUMN [mobile_insights_page_views_unique] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- B_improvado.linkedin_organic_page_statistics.mobile_jobs_page_views -> PII | Direct personal identifier
ALTER TABLE [B_improvado].[linkedin_organic_page_statistics]
  ALTER COLUMN [mobile_jobs_page_views] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- B_improvado.linkedin_organic_page_statistics.mobile_jobs_page_views_unique -> PII | Direct personal identifier
ALTER TABLE [B_improvado].[linkedin_organic_page_statistics]
  ALTER COLUMN [mobile_jobs_page_views_unique] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- B_improvado.linkedin_organic_page_statistics.mobile_life_at_page_views -> PII | Direct personal identifier
ALTER TABLE [B_improvado].[linkedin_organic_page_statistics]
  ALTER COLUMN [mobile_life_at_page_views] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- B_improvado.linkedin_organic_page_statistics.mobile_life_at_page_views_unique -> PII | Direct personal identifier
ALTER TABLE [B_improvado].[linkedin_organic_page_statistics]
  ALTER COLUMN [mobile_life_at_page_views_unique] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- B_improvado.linkedin_organic_page_statistics.mobile_overview_page_views -> PII | Direct personal identifier
ALTER TABLE [B_improvado].[linkedin_organic_page_statistics]
  ALTER COLUMN [mobile_overview_page_views] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- B_improvado.linkedin_organic_page_statistics.mobile_overview_page_views_unique -> PII | Direct personal identifier
ALTER TABLE [B_improvado].[linkedin_organic_page_statistics]
  ALTER COLUMN [mobile_overview_page_views_unique] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- B_improvado.linkedin_organic_page_statistics.mobile_people_page_views -> PII | Direct personal identifier
ALTER TABLE [B_improvado].[linkedin_organic_page_statistics]
  ALTER COLUMN [mobile_people_page_views] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- B_improvado.linkedin_organic_page_statistics.mobile_people_page_views_unique -> PII | Direct personal identifier
ALTER TABLE [B_improvado].[linkedin_organic_page_statistics]
  ALTER COLUMN [mobile_people_page_views_unique] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- B_improvado.matomo_general.actions_per_visit -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_improvado].[matomo_general]
  ALTER COLUMN [actions_per_visit] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_improvado.matomo_general.actions_per_visit_new -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_improvado].[matomo_general]
  ALTER COLUMN [actions_per_visit_new] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_improvado.matomo_general.actions_per_visit_returning -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_improvado].[matomo_general]
  ALTER COLUMN [actions_per_visit_returning] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_improvado.matomo_general.avg_time_dom_processing -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_improvado].[matomo_general]
  ALTER COLUMN [avg_time_dom_processing] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_improvado.matomo_general.dom_processing_hits -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_improvado].[matomo_general]
  ALTER COLUMN [dom_processing_hits] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_improvado.matomo_general.dom_processing_time -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_improvado].[matomo_general]
  ALTER COLUMN [dom_processing_time] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_improvado.matomo_general.new_visit_conversions -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_improvado].[matomo_general]
  ALTER COLUMN [new_visit_conversions] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_improvado.matomo_general.new_visits -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_improvado].[matomo_general]
  ALTER COLUMN [new_visits] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_improvado.matomo_general.returning_visit_conversions -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_improvado].[matomo_general]
  ALTER COLUMN [returning_visit_conversions] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_improvado.matomo_general.returning_visits -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_improvado].[matomo_general]
  ALTER COLUMN [returning_visits] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_improvado.matomo_general.revenue_new_visit -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_improvado].[matomo_general]
  ALTER COLUMN [revenue_new_visit] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_improvado.matomo_general.revenue_returning_visit -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_improvado].[matomo_general]
  ALTER COLUMN [revenue_returning_visit] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_improvado.matomo_general.sum_visit_length -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_improvado].[matomo_general]
  ALTER COLUMN [sum_visit_length] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_improvado.matomo_general.unique_new_visitors -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_improvado].[matomo_general]
  ALTER COLUMN [unique_new_visitors] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_improvado.matomo_general.unique_returning_visitors -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_improvado].[matomo_general]
  ALTER COLUMN [unique_returning_visitors] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_improvado.matomo_general.unique_visitors -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_improvado].[matomo_general]
  ALTER COLUMN [unique_visitors] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_improvado.matomo_general.visitors_from_campaigns -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_improvado].[matomo_general]
  ALTER COLUMN [visitors_from_campaigns] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_improvado.matomo_general.visitors_from_direct_entry -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_improvado].[matomo_general]
  ALTER COLUMN [visitors_from_direct_entry] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_improvado.matomo_general.visitors_from_search_engines -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_improvado].[matomo_general]
  ALTER COLUMN [visitors_from_search_engines] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_improvado.matomo_general.visitors_from_social_networks -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_improvado].[matomo_general]
  ALTER COLUMN [visitors_from_social_networks] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_improvado.matomo_general.visitors_from_websites -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_improvado].[matomo_general]
  ALTER COLUMN [visitors_from_websites] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_improvado.matomo_general.visits -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_improvado].[matomo_general]
  ALTER COLUMN [visits] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_improvado.matomo_general.visits_converted -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_improvado].[matomo_general]
  ALTER COLUMN [visits_converted] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_improvado.matomo_general.visits_converted_new_visit -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_improvado].[matomo_general]
  ALTER COLUMN [visits_converted_new_visit] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_improvado.matomo_general.visits_converted_returning_visit -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_improvado].[matomo_general]
  ALTER COLUMN [visits_converted_returning_visit] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_improvado.src_improvado_dataflow_run_events.dts_agency_whitelabel_host -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_improvado].[src_improvado_dataflow_run_events]
  ALTER COLUMN [dts_agency_whitelabel_host] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_improvado.src_improvado_order_runs_billing.notification_email -> PII | Direct personal identifier
ALTER TABLE [B_improvado].[src_improvado_order_runs_billing]
  ALTER COLUMN [notification_email] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_improvado.src_improvado_order_runs_billing.order_run_processed_rows -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_improvado].[src_improvado_order_runs_billing]
  ALTER COLUMN [order_run_processed_rows] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_improvado.src_improvado_order_runs_billing.whitelabel_host -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_improvado].[src_improvado_order_runs_billing]
  ALTER COLUMN [whitelabel_host] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_improvado.src_improvado_order_runs_billing.whitelabel_id -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_improvado].[src_improvado_order_runs_billing]
  ALTER COLUMN [whitelabel_id] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_improvado.src_improvado_order_runs_billing.whitelabel_name -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_improvado].[src_improvado_order_runs_billing]
  ALTER COLUMN [whitelabel_name] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_improvado.src_improvado_order_runs_billing.whitelabel_title -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_improvado].[src_improvado_order_runs_billing]
  ALTER COLUMN [whitelabel_title] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_improvado.unlock_daily_geostats.zip -> PII | Direct personal identifier
ALTER TABLE [B_improvado].[unlock_daily_geostats]
  ALTER COLUMN [zip] <datatype> MASKED WITH (FUNCTION = 'partial(3,'**',0)');
GO

-- B_improvado.youtube_organic_channels_all_videos_daily.subscribers_gained -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_improvado].[youtube_organic_channels_all_videos_daily]
  ALTER COLUMN [subscribers_gained] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_improvado.youtube_organic_channels_all_videos_daily.subscribers_lost -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_improvado].[youtube_organic_channels_all_videos_daily]
  ALTER COLUMN [subscribers_lost] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_lawson.deptcode.ProcessLevel -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_lawson].[deptcode]
  ALTER COLUMN [ProcessLevel] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_lawson.EDW_HR_Snapshots.PROCESS_LEVEL -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_lawson].[EDW_HR_Snapshots]
  ALTER COLUMN [PROCESS_LEVEL] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_lawson.Employee.PROCESS_LEVEL -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_lawson].[Employee]
  ALTER COLUMN [PROCESS_LEVEL] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_lawson.Employee.EMAIL_ADDRESS -> PII | Direct personal identifier
ALTER TABLE [B_lawson].[Employee]
  ALTER COLUMN [EMAIL_ADDRESS] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_lawson.HR_SNAPSHOTS.PROCESS_LEVEL -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_lawson].[HR_SNAPSHOTS]
  ALTER COLUMN [PROCESS_LEVEL] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_lawson.HR_SNAPSHOTS.BIRTHDATE -> PII | Direct personal identifier
ALTER TABLE [B_lawson].[HR_SNAPSHOTS]
  ALTER COLUMN [BIRTHDATE] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_lawson.JobCode.PROCESS_LEVEL -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_lawson].[JobCode]
  ALTER COLUMN [PROCESS_LEVEL] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_lawson.PAEmployee.SUPP_ZIP -> PII | Direct personal identifier
ALTER TABLE [B_lawson].[PAEmployee]
  ALTER COLUMN [SUPP_ZIP] <datatype> MASKED WITH (FUNCTION = 'partial(3,'**',0)');
GO

-- B_lawson.PAEmployee.HM_PHONE_CNTRY -> PII | Direct personal identifier
ALTER TABLE [B_lawson].[PAEmployee]
  ALTER COLUMN [HM_PHONE_CNTRY] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- B_lawson.PAEmployee.HM_PHONE_NBR -> PII | Direct personal identifier
ALTER TABLE [B_lawson].[PAEmployee]
  ALTER COLUMN [HM_PHONE_NBR] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- B_lawson.PAEmployee.WK_PHONE_CNTRY -> PII | Direct personal identifier
ALTER TABLE [B_lawson].[PAEmployee]
  ALTER COLUMN [WK_PHONE_CNTRY] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- B_lawson.PAEmployee.WK_PHONE_NBR -> PII | Direct personal identifier
ALTER TABLE [B_lawson].[PAEmployee]
  ALTER COLUMN [WK_PHONE_NBR] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- B_lawson.PAEmployee.WK_PHONE_EXT -> PII | Direct personal identifier
ALTER TABLE [B_lawson].[PAEmployee]
  ALTER COLUMN [WK_PHONE_EXT] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- B_lawson.PAEmployee.BIRTHDATE -> PII | Direct personal identifier
ALTER TABLE [B_lawson].[PAEmployee]
  ALTER COLUMN [BIRTHDATE] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_lawson.SN_CompanyCostCenter.PhoneNumber -> PII | Direct personal identifier
ALTER TABLE [B_lawson].[SN_CompanyCostCenter]
  ALTER COLUMN [PhoneNumber] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- B_lawson.SN_CompanyCostCenter.PostalCode -> PII | Direct personal identifier
ALTER TABLE [B_lawson].[SN_CompanyCostCenter]
  ALTER COLUMN [PostalCode] <datatype> MASKED WITH (FUNCTION = 'partial(3,'**',0)');
GO

-- B_lawson.SN_REGMKTPLLOC.Processlevel -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_lawson].[SN_REGMKTPLLOC]
  ALTER COLUMN [Processlevel] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_lawson.SN_REGMKTPLLOC.Zip -> PII | Direct personal identifier
ALTER TABLE [B_lawson].[SN_REGMKTPLLOC]
  ALTER COLUMN [Zip] <datatype> MASKED WITH (FUNCTION = 'partial(3,'**',0)');
GO

-- B_lawson.SN_Stacy_RegMktPlLoc.Processlevel -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_lawson].[SN_Stacy_RegMktPlLoc]
  ALTER COLUMN [Processlevel] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_lawson.SN_Stacy_RegMktPlLoc.Zip -> PII | Direct personal identifier
ALTER TABLE [B_lawson].[SN_Stacy_RegMktPlLoc]
  ALTER COLUMN [Zip] <datatype> MASKED WITH (FUNCTION = 'partial(3,'**',0)');
GO

-- B_lawson.Turnover.ProcessLevel -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_lawson].[Turnover]
  ALTER COLUMN [ProcessLevel] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_lawson.Turnover.FirstName -> PII | Direct personal identifier
ALTER TABLE [B_lawson].[Turnover]
  ALTER COLUMN [FirstName] <datatype> MASKED WITH (FUNCTION = 'partial(1,'***',0)');
GO

-- B_lawson.Turnover.MiddleName -> PII | Direct personal identifier
ALTER TABLE [B_lawson].[Turnover]
  ALTER COLUMN [MiddleName] <datatype> MASKED WITH (FUNCTION = 'partial(1,'***',0)');
GO

-- B_lawson.Turnover.LastName -> PII | Direct personal identifier
ALTER TABLE [B_lawson].[Turnover]
  ALTER COLUMN [LastName] <datatype> MASKED WITH (FUNCTION = 'partial(1,'***',0)');
GO

-- B_lawson.Turnover.Birthdate -> PII | Direct personal identifier
ALTER TABLE [B_lawson].[Turnover]
  ALTER COLUMN [Birthdate] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_lawson.Turnover2.PROCESS_LEVEL -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_lawson].[Turnover2]
  ALTER COLUMN [PROCESS_LEVEL] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_lawson.Turnover2.BIRTHDATE -> PII | Direct personal identifier
ALTER TABLE [B_lawson].[Turnover2]
  ALTER COLUMN [BIRTHDATE] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_leaseharbor.LeasedAndOwnedExport.Address -> PII | Direct personal identifier
ALTER TABLE [B_leaseharbor].[LeasedAndOwnedExport]
  ALTER COLUMN [Address] <datatype> MASKED WITH (FUNCTION = 'partial(0,'REDACTED',0)');
GO

-- B_leaseharbor.LeasedAndOwnedExport.Postalcode -> PII | Direct personal identifier
ALTER TABLE [B_leaseharbor].[LeasedAndOwnedExport]
  ALTER COLUMN [Postalcode] <datatype> MASKED WITH (FUNCTION = 'partial(3,'**',0)');
GO

-- B_location.EpicStatusTabHistory.ProcName -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_location].[EpicStatusTabHistory]
  ALTER COLUMN [ProcName] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_matomo.LiveLastVisits.idVisit -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_matomo].[LiveLastVisits]
  ALTER COLUMN [idVisit] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_matomo.LiveLastVisits.visitIp -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_matomo].[LiveLastVisits]
  ALTER COLUMN [visitIp] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_matomo.LiveLastVisits.visitorId -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_matomo].[LiveLastVisits]
  ALTER COLUMN [visitorId] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_matomo.LiveLastVisits.visitServerHour -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_matomo].[LiveLastVisits]
  ALTER COLUMN [visitServerHour] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_matomo.LiveLastVisits.visitorType -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_matomo].[LiveLastVisits]
  ALTER COLUMN [visitorType] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_matomo.LiveLastVisits.visitorTypeIcon -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_matomo].[LiveLastVisits]
  ALTER COLUMN [visitorTypeIcon] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_matomo.LiveLastVisits.visitConverted -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_matomo].[LiveLastVisits]
  ALTER COLUMN [visitConverted] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_matomo.LiveLastVisits.visitConvertedIcon -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_matomo].[LiveLastVisits]
  ALTER COLUMN [visitConvertedIcon] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_matomo.LiveLastVisits.visitCount -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_matomo].[LiveLastVisits]
  ALTER COLUMN [visitCount] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_matomo.LiveLastVisits.visitEcommerceStatus -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_matomo].[LiveLastVisits]
  ALTER COLUMN [visitEcommerceStatus] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_matomo.LiveLastVisits.visitEcommerceStatusIcon -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_matomo].[LiveLastVisits]
  ALTER COLUMN [visitEcommerceStatusIcon] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_matomo.LiveLastVisits.daysSinceFirstVisit -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_matomo].[LiveLastVisits]
  ALTER COLUMN [daysSinceFirstVisit] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_matomo.LiveLastVisits.secondsSinceFirstVisit -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_matomo].[LiveLastVisits]
  ALTER COLUMN [secondsSinceFirstVisit] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_matomo.LiveLastVisits.visitDuration -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_matomo].[LiveLastVisits]
  ALTER COLUMN [visitDuration] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_matomo.LiveLastVisits.visitDurationPretty -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_matomo].[LiveLastVisits]
  ALTER COLUMN [visitDurationPretty] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_matomo.LiveLastVisits.visitLocalTime -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_matomo].[LiveLastVisits]
  ALTER COLUMN [visitLocalTime] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_matomo.LiveLastVisits.visitLocalHour -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_matomo].[LiveLastVisits]
  ALTER COLUMN [visitLocalHour] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_matomo.LiveLastVisits.daysSinceLastVisit -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_matomo].[LiveLastVisits]
  ALTER COLUMN [daysSinceLastVisit] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_matomo.LiveLastVisits.secondsSinceLastVisit -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_matomo].[LiveLastVisits]
  ALTER COLUMN [secondsSinceLastVisit] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_matomo.LiveLastVisits.result -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_matomo].[LiveLastVisits]
  ALTER COLUMN [result] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_matomo.LiveLastVisits_ActionDetails.idVisit -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_matomo].[LiveLastVisits_ActionDetails]
  ALTER COLUMN [idVisit] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_matomo.LiveLastVisits_pluginsIcons.idVisit -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_matomo].[LiveLastVisits_pluginsIcons]
  ALTER COLUMN [idVisit] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_matomo.LiveLastVisits_test.visitServerHour -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_matomo].[LiveLastVisits_test]
  ALTER COLUMN [visitServerHour] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_matomo.LiveLastVisits_test.visitLocalTime -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_matomo].[LiveLastVisits_test]
  ALTER COLUMN [visitLocalTime] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_matomo.LiveLastVisits_test.visitConvertedIcon -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_matomo].[LiveLastVisits_test]
  ALTER COLUMN [visitConvertedIcon] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_matomo.LiveLastVisits_test.visitorId -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_matomo].[LiveLastVisits_test]
  ALTER COLUMN [visitorId] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_matomo.LiveLastVisits_test.visitDurationPretty -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_matomo].[LiveLastVisits_test]
  ALTER COLUMN [visitDurationPretty] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_matomo.LiveLastVisits_test.daysSinceLastVisit -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_matomo].[LiveLastVisits_test]
  ALTER COLUMN [daysSinceLastVisit] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_matomo.LiveLastVisits_test.visitEcommerceStatusIcon -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_matomo].[LiveLastVisits_test]
  ALTER COLUMN [visitEcommerceStatusIcon] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_matomo.LiveLastVisits_test.secondsSinceLastVisit -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_matomo].[LiveLastVisits_test]
  ALTER COLUMN [secondsSinceLastVisit] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_matomo.LiveLastVisits_test.visitDuration -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_matomo].[LiveLastVisits_test]
  ALTER COLUMN [visitDuration] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_matomo.LiveLastVisits_test.visitorTypeIcon -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_matomo].[LiveLastVisits_test]
  ALTER COLUMN [visitorTypeIcon] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_matomo.LiveLastVisits_test.visitEcommerceStatus -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_matomo].[LiveLastVisits_test]
  ALTER COLUMN [visitEcommerceStatus] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_matomo.LiveLastVisits_test.visitLocalHour -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_matomo].[LiveLastVisits_test]
  ALTER COLUMN [visitLocalHour] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_matomo.LiveLastVisits_test.visitCount -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_matomo].[LiveLastVisits_test]
  ALTER COLUMN [visitCount] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_matomo.LiveLastVisits_test.visitIp -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_matomo].[LiveLastVisits_test]
  ALTER COLUMN [visitIp] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_matomo.LiveLastVisits_test.secondsSinceFirstVisit -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_matomo].[LiveLastVisits_test]
  ALTER COLUMN [secondsSinceFirstVisit] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_matomo.LiveLastVisits_test.idVisit -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_matomo].[LiveLastVisits_test]
  ALTER COLUMN [idVisit] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_matomo.LiveLastVisits_test.visitConverted -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_matomo].[LiveLastVisits_test]
  ALTER COLUMN [visitConverted] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_matomo.LiveLastVisits_test.visitorType -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_matomo].[LiveLastVisits_test]
  ALTER COLUMN [visitorType] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_matomo.LiveLastVisits_test.daysSinceFirstVisit -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_matomo].[LiveLastVisits_test]
  ALTER COLUMN [daysSinceFirstVisit] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_matomo.LiveLastVisits_test_ActionDetails.idVisit -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_matomo].[LiveLastVisits_test_ActionDetails]
  ALTER COLUMN [idVisit] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_matomo.LiveLastVisits_test_PluginsIcons.idVisit -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_matomo].[LiveLastVisits_test_PluginsIcons]
  ALTER COLUMN [idVisit] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- b_poc.Employees.FirstName -> PII | Direct personal identifier
ALTER TABLE [b_poc].[Employees]
  ALTER COLUMN [FirstName] <datatype> MASKED WITH (FUNCTION = 'partial(1,'***',0)');
GO

-- b_poc.Employees.LastName -> PII | Direct personal identifier
ALTER TABLE [b_poc].[Employees]
  ALTER COLUMN [LastName] <datatype> MASKED WITH (FUNCTION = 'partial(1,'***',0)');
GO

-- b_poc.role_members_table.member_principal_id -> PHI | Contains patient-level health or encounter information
ALTER TABLE [b_poc].[role_members_table]
  ALTER COLUMN [member_principal_id] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- b_poc.role_members_table.Member_Principal_Name -> PHI | Contains patient-level health or encounter information
ALTER TABLE [b_poc].[role_members_table]
  ALTER COLUMN [Member_Principal_Name] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_powerbiaudit.PowerBIAuditLogs.ResultStatus -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_powerbiaudit].[PowerBIAuditLogs]
  ALTER COLUMN [ResultStatus] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_powerbiaudit.PowerBIAuditLogs_ArtifactAccessRequestInfo_ArtifactAccessRequestInfo_ArtifactOwnerInformation.EmailAddress -> PII | Direct personal identifier
ALTER TABLE [B_powerbiaudit].[PowerBIAuditLogs_ArtifactAccessRequestInfo_ArtifactAccessRequestInfo_ArtifactOwnerInformation]
  ALTER COLUMN [EmailAddress] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_powerbiaudit.PowerBIAuditLogs_ArtifactAccessRequestInfo_ArtifactOwnerInformation.EmailAddress -> PII | Direct personal identifier
ALTER TABLE [B_powerbiaudit].[PowerBIAuditLogs_ArtifactAccessRequestInfo_ArtifactOwnerInformation]
  ALTER COLUMN [EmailAddress] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_powerbiaudit.PowerBIAuditLogs_SharingInformation.RecipientEmail -> PII | Direct personal identifier
ALTER TABLE [B_powerbiaudit].[PowerBIAuditLogs_SharingInformation]
  ALTER COLUMN [RecipientEmail] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_powerbiaudit.PowerBIAuditLogs1.ResultStatus -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_powerbiaudit].[PowerBIAuditLogs1]
  ALTER COLUMN [ResultStatus] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_powerbiaudit.PowerBIAuditLogs1_ArtifactAccessRequestInfo_ArtifactOwnerInformation.EmailAddress -> PII | Direct personal identifier
ALTER TABLE [B_powerbiaudit].[PowerBIAuditLogs1_ArtifactAccessRequestInfo_ArtifactOwnerInformation]
  ALTER COLUMN [EmailAddress] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_powerbiaudit.PowerBIAuditLogs1_SharingInformation.RecipientEmail -> PII | Direct personal identifier
ALTER TABLE [B_powerbiaudit].[PowerBIAuditLogs1_SharingInformation]
  ALTER COLUMN [RecipientEmail] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- B_pressganey.CAHPS_SURVEYS.EncounterNum -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_pressganey].[CAHPS_SURVEYS]
  ALTER COLUMN [EncounterNum] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_pressganey.CPT_CODES.CptCodesId -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_pressganey].[CPT_CODES]
  ALTER COLUMN [CptCodesId] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_pressganey.CPT_CODES.EncounterNum -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_pressganey].[CPT_CODES]
  ALTER COLUMN [EncounterNum] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_pressganey.CPT_CODES.CptCode -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_pressganey].[CPT_CODES]
  ALTER COLUMN [CptCode] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_pressganey.CPT_CODES.DateOfProc -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_pressganey].[CPT_CODES]
  ALTER COLUMN [DateOfProc] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_pressganey.CPT_CODES.CptDateOfProc -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_pressganey].[CPT_CODES]
  ALTER COLUMN [CptDateOfProc] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_pressganey.CPT_CODES.CptModifier -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_pressganey].[CPT_CODES]
  ALTER COLUMN [CptModifier] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_rwb.Measures.PatientName -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_rwb].[Measures]
  ALTER COLUMN [PatientName] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_rwb.Measures.Mrn -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_rwb].[Measures]
  ALTER COLUMN [Mrn] <datatype> MASKED WITH (FUNCTION = 'default() or partial(0,'TOKEN-',0)');
GO

-- B_rwb.Measures.BirthDate -> PII | Direct personal identifier
ALTER TABLE [B_rwb].[Measures]
  ALTER COLUMN [BirthDate] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_rwb.Measures.QrdaPatientEthnicity -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_rwb].[Measures]
  ALTER COLUMN [QrdaPatientEthnicity] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_rwb.Measures.QrdaPatientPayer -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_rwb].[Measures]
  ALTER COLUMN [QrdaPatientPayer] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_rwb.Measures.QrdaPatientRace -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_rwb].[Measures]
  ALTER COLUMN [QrdaPatientRace] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- B_rwb.Measures.QrdaPatientSex -> PHI | Contains patient-level health or encounter information
ALTER TABLE [B_rwb].[Measures]
  ALTER COLUMN [QrdaPatientSex] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- D_mask.Patients_prd.PatientID -> PHI | Contains patient-level health or encounter information
ALTER TABLE [D_mask].[Patients_prd]
  ALTER COLUMN [PatientID] <datatype> MASKED WITH (FUNCTION = 'default() or partial(0,'TOKEN-',0)');
GO

-- D_mask.Patients_prd.SSN -> PII | Direct personal identifier
ALTER TABLE [D_mask].[Patients_prd]
  ALTER COLUMN [SSN] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XX-',4)');
GO

-- D_mask.Patients_prd.Email -> PII | Direct personal identifier
ALTER TABLE [D_mask].[Patients_prd]
  ALTER COLUMN [Email] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- D_mask.Patients_prd.Phone -> PII | Direct personal identifier
ALTER TABLE [D_mask].[Patients_prd]
  ALTER COLUMN [Phone] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- D_mask.Patients_SDM.PatientID -> PHI | Contains patient-level health or encounter information
ALTER TABLE [D_mask].[Patients_SDM]
  ALTER COLUMN [PatientID] <datatype> MASKED WITH (FUNCTION = 'default() or partial(0,'TOKEN-',0)');
GO

-- D_mask.Patients_SDM.SSN -> PII | Direct personal identifier
ALTER TABLE [D_mask].[Patients_SDM]
  ALTER COLUMN [SSN] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XX-',4)');
GO

-- D_mask.Patients_SDM.Email -> PII | Direct personal identifier
ALTER TABLE [D_mask].[Patients_SDM]
  ALTER COLUMN [Email] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- D_mask.Patients_SDM.Phone -> PII | Direct personal identifier
ALTER TABLE [D_mask].[Patients_SDM]
  ALTER COLUMN [Phone] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- D_mask.PatientsDDM.PatientID -> PHI | Contains patient-level health or encounter information
ALTER TABLE [D_mask].[PatientsDDM]
  ALTER COLUMN [PatientID] <datatype> MASKED WITH (FUNCTION = 'default() or partial(0,'TOKEN-',0)');
GO

-- D_mask.PatientsDDM.SSN -> PII | Direct personal identifier
ALTER TABLE [D_mask].[PatientsDDM]
  ALTER COLUMN [SSN] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XX-',4)');
GO

-- D_mask.PatientsDDM.Email -> PII | Direct personal identifier
ALTER TABLE [D_mask].[PatientsDDM]
  ALTER COLUMN [Email] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- D_mask.PatientsDDM.Phone -> PII | Direct personal identifier
ALTER TABLE [D_mask].[PatientsDDM]
  ALTER COLUMN [Phone] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- D_mask.PatientTokenized.PatientID -> PHI | Contains patient-level health or encounter information
ALTER TABLE [D_mask].[PatientTokenized]
  ALTER COLUMN [PatientID] <datatype> MASKED WITH (FUNCTION = 'default() or partial(0,'TOKEN-',0)');
GO

-- D_mask.PatientTokenized.SSN_Token -> PII | Direct personal identifier
ALTER TABLE [D_mask].[PatientTokenized]
  ALTER COLUMN [SSN_Token] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XX-',4)');
GO

-- dbo.B_illumicare.Data_all_ardent_2025_07_10.patient_product_tk -> PHI | Contains patient-level health or encounter information
ALTER TABLE [dbo].[B_illumicare.Data_all_ardent_2025_07_10]
  ALTER COLUMN [patient_product_tk] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- dbo.B_illumicare.Data_all_ardent_2025_07_10.mrn -> PHI | Contains patient-level health or encounter information
ALTER TABLE [dbo].[B_illumicare.Data_all_ardent_2025_07_10]
  ALTER COLUMN [mrn] <datatype> MASKED WITH (FUNCTION = 'default() or partial(0,'TOKEN-',0)');
GO

-- dbo.B_illumicare.Data_all_ardent_2025_07_10.visit_number -> PHI | Contains patient-level health or encounter information
ALTER TABLE [dbo].[B_illumicare.Data_all_ardent_2025_07_10]
  ALTER COLUMN [visit_number] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- dbo.B_illumicare.Data_all_ardent_2025_07_10.admission_datetime -> PHI | Contains patient-level health or encounter information
ALTER TABLE [dbo].[B_illumicare.Data_all_ardent_2025_07_10]
  ALTER COLUMN [admission_datetime] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- dbo.B_illumicare.Data_all_ardent_2025_07_10.discharge_datetime -> PHI | Contains patient-level health or encounter information
ALTER TABLE [dbo].[B_illumicare.Data_all_ardent_2025_07_10]
  ALTER COLUMN [discharge_datetime] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- dbo.B_illumicare.Data_all_ardent_2025_07_10.patient_class -> PHI | Contains patient-level health or encounter information
ALTER TABLE [dbo].[B_illumicare.Data_all_ardent_2025_07_10]
  ALTER COLUMN [patient_class] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- dbo.B_illumicare.Data_all_ardent_2025_07_10.current_result_normality -> PHI | Contains patient-level health or encounter information
ALTER TABLE [dbo].[B_illumicare.Data_all_ardent_2025_07_10]
  ALTER COLUMN [current_result_normality] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- dbo.B_illumicare.Data_all_ardent_2025_07_10.prior_result_normality -> PHI | Contains patient-level health or encounter information
ALTER TABLE [dbo].[B_illumicare.Data_all_ardent_2025_07_10]
  ALTER COLUMN [prior_result_normality] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- dbo.B_illumicare.Data_all_ardent_2025_07_10v2.patient_product_tk -> PHI | Contains patient-level health or encounter information
ALTER TABLE [dbo].[B_illumicare.Data_all_ardent_2025_07_10v2]
  ALTER COLUMN [patient_product_tk] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- dbo.B_illumicare.Data_all_ardent_2025_07_10v2.mrn -> PHI | Contains patient-level health or encounter information
ALTER TABLE [dbo].[B_illumicare.Data_all_ardent_2025_07_10v2]
  ALTER COLUMN [mrn] <datatype> MASKED WITH (FUNCTION = 'default() or partial(0,'TOKEN-',0)');
GO

-- dbo.B_illumicare.Data_all_ardent_2025_07_10v2.visit_number -> PHI | Contains patient-level health or encounter information
ALTER TABLE [dbo].[B_illumicare.Data_all_ardent_2025_07_10v2]
  ALTER COLUMN [visit_number] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- dbo.B_illumicare.Data_all_ardent_2025_07_10v2.admission_datetime -> PHI | Contains patient-level health or encounter information
ALTER TABLE [dbo].[B_illumicare.Data_all_ardent_2025_07_10v2]
  ALTER COLUMN [admission_datetime] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- dbo.B_illumicare.Data_all_ardent_2025_07_10v2.discharge_datetime -> PHI | Contains patient-level health or encounter information
ALTER TABLE [dbo].[B_illumicare.Data_all_ardent_2025_07_10v2]
  ALTER COLUMN [discharge_datetime] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- dbo.B_illumicare.Data_all_ardent_2025_07_10v2.patient_class -> PHI | Contains patient-level health or encounter information
ALTER TABLE [dbo].[B_illumicare.Data_all_ardent_2025_07_10v2]
  ALTER COLUMN [patient_class] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- dbo.B_illumicare.Data_all_ardent_2025_07_10v2.current_result_normality -> PHI | Contains patient-level health or encounter information
ALTER TABLE [dbo].[B_illumicare.Data_all_ardent_2025_07_10v2]
  ALTER COLUMN [current_result_normality] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- dbo.B_illumicare.Data_all_ardent_2025_07_10v2.prior_result_normality -> PHI | Contains patient-level health or encounter information
ALTER TABLE [dbo].[B_illumicare.Data_all_ardent_2025_07_10v2]
  ALTER COLUMN [prior_result_normality] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- dbo.facebook_ads_ads_creative.caption -> PII | Direct personal identifier
ALTER TABLE [dbo].[facebook_ads_ads_creative]
  ALTER COLUMN [caption] <datatype> MASKED WITH (FUNCTION = 'partial(0,'REDACTED',0)');
GO

-- dbo.facebook_ads_ads_creative.catalog_mobile_add_to_cart -> PII | Direct personal identifier
ALTER TABLE [dbo].[facebook_ads_ads_creative]
  ALTER COLUMN [catalog_mobile_add_to_cart] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- dbo.facebook_ads_ads_creative.catalog_mobile_add_to_cart_value -> PII | Direct personal identifier
ALTER TABLE [dbo].[facebook_ads_ads_creative]
  ALTER COLUMN [catalog_mobile_add_to_cart_value] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- dbo.facebook_ads_ads_creative.catalog_mobile_content_view -> PII | Direct personal identifier
ALTER TABLE [dbo].[facebook_ads_ads_creative]
  ALTER COLUMN [catalog_mobile_content_view] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- dbo.facebook_ads_ads_creative.catalog_mobile_content_view_value -> PII | Direct personal identifier
ALTER TABLE [dbo].[facebook_ads_ads_creative]
  ALTER COLUMN [catalog_mobile_content_view_value] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- dbo.facebook_ads_ads_creative.catalog_mobile_purchase -> PII | Direct personal identifier
ALTER TABLE [dbo].[facebook_ads_ads_creative]
  ALTER COLUMN [catalog_mobile_purchase] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- dbo.facebook_ads_ads_creative.catalog_mobile_purchase_value -> PII | Direct personal identifier
ALTER TABLE [dbo].[facebook_ads_ads_creative]
  ALTER COLUMN [catalog_mobile_purchase_value] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- dbo.facebook_ads_ads_creative.fb_mobile_add_payment_info -> PII | Direct personal identifier
ALTER TABLE [dbo].[facebook_ads_ads_creative]
  ALTER COLUMN [fb_mobile_add_payment_info] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- dbo.facebook_ads_ads_creative.fb_mobile_complete_registration -> PII | Direct personal identifier
ALTER TABLE [dbo].[facebook_ads_ads_creative]
  ALTER COLUMN [fb_mobile_complete_registration] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- dbo.facebook_ads_ads_creative.fb_mobile_content_view -> PII | Direct personal identifier
ALTER TABLE [dbo].[facebook_ads_ads_creative]
  ALTER COLUMN [fb_mobile_content_view] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- dbo.facebook_ads_ads_creative.fb_mobile_purchase -> PII | Direct personal identifier
ALTER TABLE [dbo].[facebook_ads_ads_creative]
  ALTER COLUMN [fb_mobile_purchase] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- dbo.facebook_ads_ads_creative.mobile_app_install -> PII | Direct personal identifier
ALTER TABLE [dbo].[facebook_ads_ads_creative]
  ALTER COLUMN [mobile_app_install] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- dbo.facebook_ads_ads_creative.mobile_click_through -> PII | Direct personal identifier
ALTER TABLE [dbo].[facebook_ads_ads_creative]
  ALTER COLUMN [mobile_click_through] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- dbo.facebook_ads_ads_creative.mobile_view_through -> PII | Direct personal identifier
ALTER TABLE [dbo].[facebook_ads_ads_creative]
  ALTER COLUMN [mobile_view_through] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- dbo.facebook_ads_ads_creative.schedule_mobile_app -> PII | Direct personal identifier
ALTER TABLE [dbo].[facebook_ads_ads_creative]
  ALTER COLUMN [schedule_mobile_app] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- dbo.facebook_ads_ads_creative.start_trial_mobile_app -> PII | Direct personal identifier
ALTER TABLE [dbo].[facebook_ads_ads_creative]
  ALTER COLUMN [start_trial_mobile_app] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- dbo.google_ads_ads.ad_group_ad_label_ids -> PHI | Contains patient-level health or encounter information
ALTER TABLE [dbo].[google_ads_ads]
  ALTER COLUMN [ad_group_ad_label_ids] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- dbo.google_ads_ads.ad_group_ad_labels -> PHI | Contains patient-level health or encounter information
ALTER TABLE [dbo].[google_ads_ads]
  ALTER COLUMN [ad_group_ad_labels] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- dbo.google_ads_ads.ad_group_labels -> PHI | Contains patient-level health or encounter information
ALTER TABLE [dbo].[google_ads_ads]
  ALTER COLUMN [ad_group_labels] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- dbo.google_ads_ads.ad_mobile_final_url -> PII | Direct personal identifier
ALTER TABLE [dbo].[google_ads_ads]
  ALTER COLUMN [ad_mobile_final_url] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- dbo.google_ads_ads.campaign_label_ids -> PHI | Contains patient-level health or encounter information
ALTER TABLE [dbo].[google_ads_ads]
  ALTER COLUMN [campaign_label_ids] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- dbo.google_ads_ads.campaign_label_names -> PHI | Contains patient-level health or encounter information
ALTER TABLE [dbo].[google_ads_ads]
  ALTER COLUMN [campaign_label_names] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- dbo.google_ads_campaign.campaign_label_ids -> PHI | Contains patient-level health or encounter information
ALTER TABLE [dbo].[google_ads_campaign]
  ALTER COLUMN [campaign_label_ids] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- dbo.google_ads_campaign.campaign_labels -> PHI | Contains patient-level health or encounter information
ALTER TABLE [dbo].[google_ads_campaign]
  ALTER COLUMN [campaign_labels] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- dbo.src_improvado_dataflow_run_events.dts_agency_whitelabel_host -> PHI | Contains patient-level health or encounter information
ALTER TABLE [dbo].[src_improvado_dataflow_run_events]
  ALTER COLUMN [dts_agency_whitelabel_host] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- dbo.src_improvado_order_runs_billing.notification_email -> PII | Direct personal identifier
ALTER TABLE [dbo].[src_improvado_order_runs_billing]
  ALTER COLUMN [notification_email] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- dbo.src_improvado_order_runs_billing.order_run_processed_rows -> PHI | Contains patient-level health or encounter information
ALTER TABLE [dbo].[src_improvado_order_runs_billing]
  ALTER COLUMN [order_run_processed_rows] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- dbo.src_improvado_order_runs_billing.whitelabel_host -> PHI | Contains patient-level health or encounter information
ALTER TABLE [dbo].[src_improvado_order_runs_billing]
  ALTER COLUMN [whitelabel_host] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- dbo.src_improvado_order_runs_billing.whitelabel_id -> PHI | Contains patient-level health or encounter information
ALTER TABLE [dbo].[src_improvado_order_runs_billing]
  ALTER COLUMN [whitelabel_id] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- dbo.src_improvado_order_runs_billing.whitelabel_name -> PHI | Contains patient-level health or encounter information
ALTER TABLE [dbo].[src_improvado_order_runs_billing]
  ALTER COLUMN [whitelabel_name] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- dbo.src_improvado_order_runs_billing.whitelabel_title -> PHI | Contains patient-level health or encounter information
ALTER TABLE [dbo].[src_improvado_order_runs_billing]
  ALTER COLUMN [whitelabel_title] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- dbo.unlock_daily_geostats.zip -> PII | Direct personal identifier
ALTER TABLE [dbo].[unlock_daily_geostats]
  ALTER COLUMN [zip] <datatype> MASKED WITH (FUNCTION = 'partial(3,'**',0)');
GO

-- dbo.ZZ_POS.Patientkey -> PHI | Contains patient-level health or encounter information
ALTER TABLE [dbo].[ZZ_POS]
  ALTER COLUMN [Patientkey] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- dbo.ZZ_POS.FirstEncounterKey -> PHI | Contains patient-level health or encounter information
ALTER TABLE [dbo].[ZZ_POS]
  ALTER COLUMN [FirstEncounterKey] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- dbo.ZZ_POS.FirstEncounterDateKey -> PHI | Contains patient-level health or encounter information
ALTER TABLE [dbo].[ZZ_POS]
  ALTER COLUMN [FirstEncounterDateKey] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- dbo.ZZ_POS.PrimaryDiagnosisKey -> PHI | Contains patient-level health or encounter information
ALTER TABLE [dbo].[ZZ_POS]
  ALTER COLUMN [PrimaryDiagnosisKey] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- dbo.ZZ_POS.DiagnosisComboKey -> PHI | Contains patient-level health or encounter information
ALTER TABLE [dbo].[ZZ_POS]
  ALTER COLUMN [DiagnosisComboKey] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- dbo.ZZ_Update Data.PatientKey -> PHI | Contains patient-level health or encounter information
ALTER TABLE [dbo].[ZZ_Update Data]
  ALTER COLUMN [PatientKey] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- dbo.ZZ_Update Data.PrimaryMrn -> PHI | Contains patient-level health or encounter information
ALTER TABLE [dbo].[ZZ_Update Data]
  ALTER COLUMN [PrimaryMrn] <datatype> MASKED WITH (FUNCTION = 'default() or partial(0,'TOKEN-',0)');
GO

-- S_clinical.AvailabilityHours.Unavailablereason -> PHI | Contains patient-level health or encounter information
ALTER TABLE [S_clinical].[AvailabilityHours]
  ALTER COLUMN [Unavailablereason] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- S_clinical.CmsDiabeticBloodPressure.Encounterepiccsn -> PHI | Contains patient-level health or encounter information
ALTER TABLE [S_clinical].[CmsDiabeticBloodPressure]
  ALTER COLUMN [Encounterepiccsn] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- S_clinical.CmsDiabeticBloodPressure.Encounterkey -> PHI | Contains patient-level health or encounter information
ALTER TABLE [S_clinical].[CmsDiabeticBloodPressure]
  ALTER COLUMN [Encounterkey] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- S_clinical.CmsDiabeticBloodPressure.Patientdurablekey -> PHI | Contains patient-level health or encounter information
ALTER TABLE [S_clinical].[CmsDiabeticBloodPressure]
  ALTER COLUMN [Patientdurablekey] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- S_clinical.FactReferral.Patientkey -> PHI | Contains patient-level health or encounter information
ALTER TABLE [S_clinical].[FactReferral]
  ALTER COLUMN [Patientkey] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- S_clinical.FactReferral.FirstEncounterKey -> PHI | Contains patient-level health or encounter information
ALTER TABLE [S_clinical].[FactReferral]
  ALTER COLUMN [FirstEncounterKey] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- S_clinical.FactReferral.FirstEncounterDateKey -> PHI | Contains patient-level health or encounter information
ALTER TABLE [S_clinical].[FactReferral]
  ALTER COLUMN [FirstEncounterDateKey] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- S_clinical.FactReferral.PrimaryDiagnosisKey -> PHI | Contains patient-level health or encounter information
ALTER TABLE [S_clinical].[FactReferral]
  ALTER COLUMN [PrimaryDiagnosisKey] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- S_clinical.FactReferral.DiagnosisComboKey -> PHI | Contains patient-level health or encounter information
ALTER TABLE [S_clinical].[FactReferral]
  ALTER COLUMN [DiagnosisComboKey] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- S_common.EpicLocation.addressline1 -> PII | Direct personal identifier
ALTER TABLE [S_common].[EpicLocation]
  ALTER COLUMN [addressline1] <datatype> MASKED WITH (FUNCTION = 'partial(0,'REDACTED',0)');
GO

-- S_common.EpicLocation.addressline2 -> PII | Direct personal identifier
ALTER TABLE [S_common].[EpicLocation]
  ALTER COLUMN [addressline2] <datatype> MASKED WITH (FUNCTION = 'partial(0,'REDACTED',0)');
GO

-- S_common.EpicLocation.zip -> PII | Direct personal identifier
ALTER TABLE [S_common].[EpicLocation]
  ALTER COLUMN [zip] <datatype> MASKED WITH (FUNCTION = 'partial(3,'**',0)');
GO

-- S_common.EpicLocation.processcode -> PHI | Contains patient-level health or encounter information
ALTER TABLE [S_common].[EpicLocation]
  ALTER COLUMN [processcode] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- S_common.EpicLocation.Bedlabel -> PHI | Contains patient-level health or encounter information
ALTER TABLE [S_common].[EpicLocation]
  ALTER COLUMN [Bedlabel] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- S_common.LawsonAddress.LawsonAddressKey -> PII | Direct personal identifier
ALTER TABLE [S_common].[LawsonAddress]
  ALTER COLUMN [LawsonAddressKey] <datatype> MASKED WITH (FUNCTION = 'partial(0,'REDACTED',0)');
GO

-- S_common.LawsonAddress.Zip -> PII | Direct personal identifier
ALTER TABLE [S_common].[LawsonAddress]
  ALTER COLUMN [Zip] <datatype> MASKED WITH (FUNCTION = 'partial(3,'**',0)');
GO

-- S_common.LawsonAddress.Phone -> PII | Direct personal identifier
ALTER TABLE [S_common].[LawsonAddress]
  ALTER COLUMN [Phone] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- S_common.LawsonAddress.PhoneExt -> PII | Direct personal identifier
ALTER TABLE [S_common].[LawsonAddress]
  ALTER COLUMN [PhoneExt] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- S_common.LawsonAddress.EmailAddress -> PII | Direct personal identifier
ALTER TABLE [S_common].[LawsonAddress]
  ALTER COLUMN [EmailAddress] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- S_common.LawsonAddress.SuppZip -> PII | Direct personal identifier
ALTER TABLE [S_common].[LawsonAddress]
  ALTER COLUMN [SuppZip] <datatype> MASKED WITH (FUNCTION = 'partial(3,'**',0)');
GO

-- S_common.LocAddress.LocAddressKey -> PII | Direct personal identifier
ALTER TABLE [S_common].[LocAddress]
  ALTER COLUMN [LocAddressKey] <datatype> MASKED WITH (FUNCTION = 'partial(0,'REDACTED',0)');
GO

-- S_common.LocAddress.StreetAddress1 -> PII | Direct personal identifier
ALTER TABLE [S_common].[LocAddress]
  ALTER COLUMN [StreetAddress1] <datatype> MASKED WITH (FUNCTION = 'partial(0,'REDACTED',0)');
GO

-- S_common.LocAddress.StreetAddress2 -> PII | Direct personal identifier
ALTER TABLE [S_common].[LocAddress]
  ALTER COLUMN [StreetAddress2] <datatype> MASKED WITH (FUNCTION = 'partial(0,'REDACTED',0)');
GO

-- S_common.LocAddress.ZipCode -> PII | Direct personal identifier
ALTER TABLE [S_common].[LocAddress]
  ALTER COLUMN [ZipCode] <datatype> MASKED WITH (FUNCTION = 'partial(3,'**',0)');
GO

-- S_common.Location.LocAddressKey -> PII | Direct personal identifier
ALTER TABLE [S_common].[Location]
  ALTER COLUMN [LocAddressKey] <datatype> MASKED WITH (FUNCTION = 'partial(0,'REDACTED',0)');
GO

-- S_common.LocContact.ContactFirstName -> PII | Direct personal identifier
ALTER TABLE [S_common].[LocContact]
  ALTER COLUMN [ContactFirstName] <datatype> MASKED WITH (FUNCTION = 'partial(1,'***',0)');
GO

-- S_common.LocContact.ContactMiddleName -> PII | Direct personal identifier
ALTER TABLE [S_common].[LocContact]
  ALTER COLUMN [ContactMiddleName] <datatype> MASKED WITH (FUNCTION = 'partial(1,'***',0)');
GO

-- S_common.LocContact.ContactLastName -> PII | Direct personal identifier
ALTER TABLE [S_common].[LocContact]
  ALTER COLUMN [ContactLastName] <datatype> MASKED WITH (FUNCTION = 'partial(1,'***',0)');
GO

-- S_common.LocContactDetail.Phone -> PII | Direct personal identifier
ALTER TABLE [S_common].[LocContactDetail]
  ALTER COLUMN [Phone] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- S_common.LocContactDetail.PhoneExtention -> PII | Direct personal identifier
ALTER TABLE [S_common].[LocContactDetail]
  ALTER COLUMN [PhoneExtention] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- S_common.LocContactDetail.Email -> PII | Direct personal identifier
ALTER TABLE [S_common].[LocContactDetail]
  ALTER COLUMN [Email] <datatype> MASKED WITH (FUNCTION = 'email()');
GO

-- S_common.PatientDim.PatientKey -> PHI | Contains patient-level health or encounter information
ALTER TABLE [S_common].[PatientDim]
  ALTER COLUMN [PatientKey] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- S_common.PatientDim.PrimaryMrn -> PHI | Contains patient-level health or encounter information
ALTER TABLE [S_common].[PatientDim]
  ALTER COLUMN [PrimaryMrn] <datatype> MASKED WITH (FUNCTION = 'default() or partial(0,'TOKEN-',0)');
GO

-- S_common.SN_Company.ProcessLevel -> PHI | Contains patient-level health or encounter information
ALTER TABLE [S_common].[SN_Company]
  ALTER COLUMN [ProcessLevel] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- S_common.SN_CompanyCostCenter.PHONENUMBER -> PII | Direct personal identifier
ALTER TABLE [S_common].[SN_CompanyCostCenter]
  ALTER COLUMN [PHONENUMBER] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XXX-',4)');
GO

-- S_common.SN_CompanyCostCenter.ZIPCODE -> PII | Direct personal identifier
ALTER TABLE [S_common].[SN_CompanyCostCenter]
  ALTER COLUMN [ZIPCODE] <datatype> MASKED WITH (FUNCTION = 'partial(3,'**',0)');
GO

-- S_common.SN_Location.Zip -> PII | Direct personal identifier
ALTER TABLE [S_common].[SN_Location]
  ALTER COLUMN [Zip] <datatype> MASKED WITH (FUNCTION = 'partial(3,'**',0)');
GO

-- S_common.SN_Location_ProcessCode.ProcessLevel -> PHI | Contains patient-level health or encounter information
ALTER TABLE [S_common].[SN_Location_ProcessCode]
  ALTER COLUMN [ProcessLevel] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- S_common.SN_Region_Location_ProcessCode.ProcessLevel -> PHI | Contains patient-level health or encounter information
ALTER TABLE [S_common].[SN_Region_Location_ProcessCode]
  ALTER COLUMN [ProcessLevel] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- S_rwb.Measures.PatientName -> PHI | Contains patient-level health or encounter information
ALTER TABLE [S_rwb].[Measures]
  ALTER COLUMN [PatientName] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- S_rwb.Measures.mrn -> PHI | Contains patient-level health or encounter information
ALTER TABLE [S_rwb].[Measures]
  ALTER COLUMN [mrn] <datatype> MASKED WITH (FUNCTION = 'default() or partial(0,'TOKEN-',0)');
GO

-- S_rwb.Measures.BirthDate -> PII | Direct personal identifier
ALTER TABLE [S_rwb].[Measures]
  ALTER COLUMN [BirthDate] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- S_rwb.Measures.QrdaPatientEthnicity -> PHI | Contains patient-level health or encounter information
ALTER TABLE [S_rwb].[Measures]
  ALTER COLUMN [QrdaPatientEthnicity] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- S_rwb.Measures.QrdaPatientPayer -> PHI | Contains patient-level health or encounter information
ALTER TABLE [S_rwb].[Measures]
  ALTER COLUMN [QrdaPatientPayer] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- S_rwb.Measures.QrdaPatientRace -> PHI | Contains patient-level health or encounter information
ALTER TABLE [S_rwb].[Measures]
  ALTER COLUMN [QrdaPatientRace] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- S_rwb.Measures.QrdaPatientSex -> PHI | Contains patient-level health or encounter information
ALTER TABLE [S_rwb].[Measures]
  ALTER COLUMN [QrdaPatientSex] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- TERA.EpicStatusTabHistory.ProcName -> PHI | Contains patient-level health or encounter information
ALTER TABLE [TERA].[EpicStatusTabHistory]
  ALTER COLUMN [ProcName] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- TERA.ETL_Job_Log.Records_Processed -> PHI | Contains patient-level health or encounter information
ALTER TABLE [TERA].[ETL_Job_Log]
  ALTER COLUMN [Records_Processed] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- TERA.ETL_Metadata_Log.DQ_Check_Result -> PHI | Contains patient-level health or encounter information
ALTER TABLE [TERA].[ETL_Metadata_Log]
  ALTER COLUMN [DQ_Check_Result] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- TERA.ETL_Record_Error_Log.Processed_Timestamp -> PHI | Contains patient-level health or encounter information
ALTER TABLE [TERA].[ETL_Record_Error_Log]
  ALTER COLUMN [Processed_Timestamp] <datatype> MASKED WITH (FUNCTION = 'default()');
GO

-- TERA.ETLPerfTracking.ProcessName -> PHI | Contains patient-level health or encounter information
ALTER TABLE [TERA].[ETLPerfTracking]
  ALTER COLUMN [ProcessName] <datatype> MASKED WITH (FUNCTION = 'partial(0,'XXX-XX-',4)');
GO

-- TERA.ETLPerfTracking.RowsProcessed -> PHI | Contains patient-level health or encounter information
ALTER TABLE [TERA].[ETLPerfTracking]
  ALTER COLUMN [RowsProcessed] <datatype> MASKED WITH (FUNCTION = 'default()');
GO
