

---smart masking

BEGIN TRAN;
--------------------------------------------------------------------------------
-- 1) DateOfBirth: random age between 18 and 90 (no link to real DOB)
--------------------------------------------------------------------------------
UPDATE p
SET DateOfBirth =
    CASE 
        WHEN DateOfBirth IS NOT NULL THEN
            DATEFROMPARTS(
                -- Random year between 1935 and 2007 (approx 18–90 years old)
                ABS(CHECKSUM(NEWID())) % (2007 - 1935 + 1) + 1935,
                -- Random month 1–12
                ABS(CHECKSUM(NEWID())) % 12 + 1,
                -- Random day 1–28 (safe for all months)
                ABS(CHECKSUM(NEWID())) % 28 + 1
            )
        ELSE NULL
    END
FROM dbo.PatientTestDevMasking p;
--------------------------------------------------------------------------------
-- 2) Address fields: realistic-ish but non-identifying
--------------------------------------------------------------------------------
UPDATE p
SET AddressStreet1 =
        CASE WHEN AddressStreet1 IS NOT NULL 
             THEN CONCAT('Street ', ABS(CHECKSUM(NEWID())) % 9999 + 1)
             ELSE NULL
        END,
    AddressStreet2 = NULL,
    AddressCity =
        CASE WHEN AddressCity IS NOT NULL
             THEN CONCAT('City_', ABS(CHECKSUM(NEWID())) % 1000)
             ELSE NULL
        END,
    AddressZip =
        CASE WHEN AddressZip IS NOT NULL
             THEN RIGHT('00000' + CAST(ABS(CHECKSUM(NEWID())) % 100000 AS varchar(5)), 5)
             ELSE NULL
        END
FROM dbo.PatientTestDevMasking p;
--------------------------------------------------------------------------------
-- 3) Names: fake but name-like
--------------------------------------------------------------------------------
UPDATE p
SET PatientFirstName =
        CASE WHEN PatientFirstName IS NOT NULL
             THEN CONCAT('First', ABS(CHECKSUM(NEWID())) % 5000)
             ELSE NULL
        END,
    PatientLastName  =
        CASE WHEN PatientLastName IS NOT NULL
             THEN CONCAT('Last', ABS(CHECKSUM(NEWID())) % 5000)
             ELSE NULL
        END,
    EmergencyContactName =
        CASE WHEN EmergencyContactName IS NOT NULL
             THEN CONCAT('Contact', ABS(CHECKSUM(NEWID())) % 5000)
             ELSE NULL
        END
FROM dbo.PatientTestDevMasking p;
--------------------------------------------------------------------------------
-- 4) Phones: random 10-digit phones in ###-###-#### format
--------------------------------------------------------------------------------
UPDATE p
SET HomePhone =
        CASE WHEN HomePhone IS NOT NULL THEN
            CONCAT(
                RIGHT('000' + CAST(ABS(CHECKSUM(NEWID())) % 1000 AS varchar(3)),3),
                '-',
                RIGHT('000' + CAST(ABS(CHECKSUM(NEWID())) % 1000 AS varchar(3)),3),
                '-',
                RIGHT('0000' + CAST(ABS(CHECKSUM(NEWID())) % 10000 AS varchar(4)),4)
            )
            ELSE NULL
        END,
    WorkPhone =
        CASE WHEN WorkPhone IS NOT NULL THEN
            CONCAT(
                RIGHT('000' + CAST(ABS(CHECKSUM(NEWID())) % 1000 AS varchar(3)),3),
                '-',
                RIGHT('000' + CAST(ABS(CHECKSUM(NEWID())) % 1000 AS varchar(3)),3),
                '-',
                RIGHT('0000' + CAST(ABS(CHECKSUM(NEWID())) % 10000 AS varchar(4)),4)
            )
            ELSE NULL
        END,
    MobilePhone =
        CASE WHEN MobilePhone IS NOT NULL THEN
            CONCAT(
                RIGHT('000' + CAST(ABS(CHECKSUM(NEWID())) % 1000 AS varchar(3)),3),
                '-',
                RIGHT('000' + CAST(ABS(CHECKSUM(NEWID())) % 1000 AS varchar(3)),3),
                '-',
                RIGHT('0000' + CAST(ABS(CHECKSUM(NEWID())) % 10000 AS varchar(4)),4)
            )
            ELSE NULL
        END,
    PrimaryPhone =
        CASE WHEN PrimaryPhone IS NOT NULL THEN
            CONCAT(
                RIGHT('000' + CAST(ABS(CHECKSUM(NEWID())) % 1000 AS varchar(3)),3),
                '-',
                RIGHT('000' + CAST(ABS(CHECKSUM(NEWID())) % 1000 AS varchar(3)),3),
                '-',
                RIGHT('0000' + CAST(ABS(CHECKSUM(NEWID())) % 10000 AS varchar(4)),4)
            )
            ELSE NULL
        END,
    SecondaryPhone =
        CASE WHEN SecondaryPhone IS NOT NULL THEN
            CONCAT(
                RIGHT('000' + CAST(ABS(CHECKSUM(NEWID())) % 1000 AS varchar(3)),3),
                '-',
                RIGHT('000' + CAST(ABS(CHECKSUM(NEWID())) % 1000 AS varchar(3)),3),
                '-',
                RIGHT('0000' + CAST(ABS(CHECKSUM(NEWID())) % 10000 AS varchar(4)),4)
            )
            ELSE NULL
        END,
    HomePhoneRelationship =
        CASE WHEN HomePhoneRelationship IS NOT NULL THEN
            CONCAT(
                RIGHT('000' + CAST(ABS(CHECKSUM(NEWID())) % 1000 AS varchar(3)),3),
                '-',
                RIGHT('000' + CAST(ABS(CHECKSUM(NEWID())) % 1000 AS varchar(3)),3),
                '-',
                RIGHT('0000' + CAST(ABS(CHECKSUM(NEWID())) % 10000 AS varchar(4)),4)
            )
            ELSE NULL
        END,
    MobilePhoneRelationship =
        CASE WHEN MobilePhoneRelationship IS NOT NULL THEN
            CONCAT(
                RIGHT('000' + CAST(ABS(CHECKSUM(NEWID())) % 1000 AS varchar(3)),3),
                '-',
                RIGHT('000' + CAST(ABS(CHECKSUM(NEWID())) % 1000 AS varchar(3)),3),
                '-',
                RIGHT('0000' + CAST(ABS(CHECKSUM(NEWID())) % 10000 AS varchar(4)),4)
            )
            ELSE NULL
        END
FROM dbo.PatientTestDevMasking p;
--------------------------------------------------------------------------------
-- 5) Emails: random username, keep domain if present
--------------------------------------------------------------------------------
UPDATE p
SET PrimaryEmail =
        CASE WHEN PrimaryEmail IS NOT NULL THEN
            CASE WHEN CHARINDEX('@', PrimaryEmail) > 0 THEN
                    CONCAT(
                        'user',
                        ABS(CHECKSUM(NEWID())) % 100000,
                        SUBSTRING(PrimaryEmail, CHARINDEX('@', PrimaryEmail), 4000)
                    )
                 ELSE
                    CONCAT('user', ABS(CHECKSUM(NEWID())) % 100000, '@masked.local')
            END
            ELSE NULL
        END,
    SecondaryEmail =
        CASE WHEN SecondaryEmail IS NOT NULL THEN
            CASE WHEN CHARINDEX('@', SecondaryEmail) > 0 THEN
                    CONCAT(
                        'user',
                        ABS(CHECKSUM(NEWID())) % 100000,
                        SUBSTRING(SecondaryEmail, CHARINDEX('@', SecondaryEmail), 4000)
                    )
                 ELSE
                    CONCAT('user', ABS(CHECKSUM(NEWID())) % 100000, '@masked.local')
            END
            ELSE NULL
        END,
    RelationshipEmail =
        CASE WHEN RelationshipEmail IS NOT NULL THEN
            CASE WHEN CHARINDEX('@', RelationshipEmail) > 0 THEN
                    CONCAT(
                        'rel',
                        ABS(CHECKSUM(NEWID())) % 100000,
                        SUBSTRING(RelationshipEmail, CHARINDEX('@', RelationshipEmail), 4000)
                    )
                 ELSE
                    CONCAT('rel', ABS(CHECKSUM(NEWID())) % 100000, '@masked.local')
            END
            ELSE NULL
        END
FROM dbo.PatientTestDevMasking p;
--------------------------------------------------------------------------------
-- 6) SSN & MemberNumber: random-looking, fixed length
--------------------------------------------------------------------------------
UPDATE p
SET SSN =
        CASE WHEN SSN IS NOT NULL THEN
            RIGHT(
                '000000000' + CAST(ABS(CHECKSUM(NEWID())) % 1000000000 AS varchar(9)),
                9
            )
            ELSE NULL
        END,
    MemberNumber =
        CASE WHEN MemberNumber IS NOT NULL THEN
            LEFT(
                CONVERT(varchar(64),
                        HASHBYTES('SHA2_256', CAST(MemberNumber AS varchar(50))), 2),
                LEN(MemberNumber)
            )
            ELSE NULL
        END
FROM dbo.PatientTestDevMasking p;
--------------------------------------------------------------------------------
COMMIT TRAN;




----+++++++++++++++++++++++++++++++Triger+++++++++++++++++++++++++++++++++++++++++++++++
CREATE OR ALTER TRIGGER trg_Mask_PatientTestDevMasking_Smart
ON dbo.PatientTestDevMasking
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Mask only the rows that were just inserted/updated
    UPDATE p
    SET 
        ------------------------------------------------------------------
        -- 1) DateOfBirth: random age between 18 and 90
        ------------------------------------------------------------------
        DateOfBirth =
            CASE 
                WHEN i.DateOfBirth IS NOT NULL THEN
                    DATEFROMPARTS(
                        -- Random year between 1935 and 2007
                        ABS(CHECKSUM(NEWID())) % (2007 - 1935 + 1) + 1935,
                        -- Random month 1–12
                        ABS(CHECKSUM(NEWID())) % 12 + 1,
                        -- Random day 1–28
                        ABS(CHECKSUM(NEWID())) % 28 + 1
                    )
                ELSE NULL
            END,

        ------------------------------------------------------------------
        -- 2) Address: fake but realistic-ish
        ------------------------------------------------------------------
        AddressStreet1 =
            CASE WHEN i.AddressStreet1 IS NOT NULL 
                 THEN CONCAT('Street ', ABS(CHECKSUM(NEWID())) % 9999 + 1)
                 ELSE NULL
            END,
        AddressStreet2 = NULL,
        AddressCity =
            CASE WHEN i.AddressCity IS NOT NULL
                 THEN CONCAT('City_', ABS(CHECKSUM(NEWID())) % 1000)
                 ELSE NULL
            END,
        AddressZip =
            CASE WHEN i.AddressZip IS NOT NULL
                 THEN RIGHT('00000' + CAST(ABS(CHECKSUM(NEWID())) % 100000 AS varchar(5)), 5)
                 ELSE NULL
            END,

        ------------------------------------------------------------------
        -- 3) Names: fake but name-like
        ------------------------------------------------------------------
        PatientFirstName =
            CASE WHEN i.PatientFirstName IS NOT NULL
                 THEN CONCAT('First', ABS(CHECKSUM(NEWID())) % 5000)
                 ELSE NULL
            END,
        PatientLastName  =
            CASE WHEN i.PatientLastName IS NOT NULL
                 THEN CONCAT('Last', ABS(CHECKSUM(NEWID())) % 5000)
                 ELSE NULL
            END,
        EmergencyContactName =
            CASE WHEN i.EmergencyContactName IS NOT NULL
                 THEN CONCAT('Contact', ABS(CHECKSUM(NEWID())) % 5000)
                 ELSE NULL
            END,

        ------------------------------------------------------------------
        -- 4) Phones: random 10-digit phones in ###-###-#### format
        ------------------------------------------------------------------
        HomePhone =
            CASE WHEN i.HomePhone IS NOT NULL THEN
                CONCAT(
                    RIGHT('000' + CAST(ABS(CHECKSUM(NEWID())) % 1000 AS varchar(3)),3),
                    '-',
                    RIGHT('000' + CAST(ABS(CHECKSUM(NEWID())) % 1000 AS varchar(3)),3),
                    '-',
                    RIGHT('0000' + CAST(ABS(CHECKSUM(NEWID())) % 10000 AS varchar(4)),4)
                )
            ELSE NULL
            END,
        WorkPhone =
            CASE WHEN i.WorkPhone IS NOT NULL THEN
                CONCAT(
                    RIGHT('000' + CAST(ABS(CHECKSUM(NEWID())) % 1000 AS varchar(3)),3),
                    '-',
                    RIGHT('000' + CAST(ABS(CHECKSUM(NEWID())) % 1000 AS varchar(3)),3),
                    '-',
                    RIGHT('0000' + CAST(ABS(CHECKSUM(NEWID())) % 10000 AS varchar(4)),4)
                )
            ELSE NULL
            END,
        MobilePhone =
            CASE WHEN i.MobilePhone IS NOT NULL THEN
                CONCAT(
                    RIGHT('000' + CAST(ABS(CHECKSUM(NEWID())) % 1000 AS varchar(3)),3),
                    '-',
                    RIGHT('000' + CAST(ABS(CHECKSUM(NEWID())) % 1000 AS varchar(3)),3),
                    '-',
                    RIGHT('0000' + CAST(ABS(CHECKSUM(NEWID())) % 10000 AS varchar(4)),4)
                )
            ELSE NULL
            END,
        PrimaryPhone =
            CASE WHEN i.PrimaryPhone IS NOT NULL THEN
                CONCAT(
                    RIGHT('000' + CAST(ABS(CHECKSUM(NEWID())) % 1000 AS varchar(3)),3),
                    '-',
                    RIGHT('000' + CAST(ABS(CHECKSUM(NEWID())) % 1000 AS varchar(3)),3),
                    '-',
                    RIGHT('0000' + CAST(ABS(CHECKSUM(NEWID())) % 10000 AS varchar(4)),4)
                )
            ELSE NULL
            END,
        SecondaryPhone =
            CASE WHEN i.SecondaryPhone IS NOT NULL THEN
                CONCAT(
                    RIGHT('000' + CAST(ABS(CHECKSUM(NEWID())) % 1000 AS varchar(3)),3),
                    '-',
                    RIGHT('000' + CAST(ABS(CHECKSUM(NEWID())) % 1000 AS varchar(3)),3),
                    '-',
                    RIGHT('0000' + CAST(ABS(CHECKSUM(NEWID())) % 10000 AS varchar(4)),4)
                )
            ELSE NULL
            END,
        HomePhoneRelationship =
            CASE WHEN i.HomePhoneRelationship IS NOT NULL THEN
                CONCAT(
                    RIGHT('000' + CAST(ABS(CHECKSUM(NEWID())) % 1000 AS varchar(3)),3),
                    '-',
                    RIGHT('000' + CAST(ABS(CHECKSUM(NEWID())) % 1000 AS varchar(3)),3),
                    '-',
                    RIGHT('0000' + CAST(ABS(CHECKSUM(NEWID())) % 10000 AS varchar(4)),4)
                )
            ELSE NULL
            END,
        MobilePhoneRelationship =
            CASE WHEN i.MobilePhoneRelationship IS NOT NULL THEN
                CONCAT(
                    RIGHT('000' + CAST(ABS(CHECKSUM(NEWID())) % 1000 AS varchar(3)),3),
                    '-',
                    RIGHT('000' + CAST(ABS(CHECKSUM(NEWID())) % 1000 AS varchar(3)),3),
                    '-',
                    RIGHT('0000' + CAST(ABS(CHECKSUM(NEWID())) % 10000 AS varchar(4)),4)
                )
            ELSE NULL
            END,

        ------------------------------------------------------------------
        -- 5) Emails: random username, keep domain if present
        ------------------------------------------------------------------
        PrimaryEmail =
            CASE WHEN i.PrimaryEmail IS NOT NULL THEN
                CASE WHEN CHARINDEX('@', i.PrimaryEmail) > 0 THEN
                        CONCAT(
                            'user',
                            ABS(CHECKSUM(NEWID())) % 100000,
                            SUBSTRING(i.PrimaryEmail, CHARINDEX('@', i.PrimaryEmail), 4000)
                        )
                     ELSE
                        CONCAT('user', ABS(CHECKSUM(NEWID())) % 100000, '@masked.local')
                END
            ELSE NULL
            END,
        SecondaryEmail =
            CASE WHEN i.SecondaryEmail IS NOT NULL THEN
                CASE WHEN CHARINDEX('@', i.SecondaryEmail) > 0 THEN
                        CONCAT(
                            'user',
                            ABS(CHECKSUM(NEWID())) % 100000,
                            SUBSTRING(i.SecondaryEmail, CHARINDEX('@', i.SecondaryEmail), 4000)
                        )
                     ELSE
                        CONCAT('user', ABS(CHECKSUM(NEWID())) % 100000, '@masked.local')
                END
            ELSE NULL
            END,
        RelationshipEmail =
            CASE WHEN i.RelationshipEmail IS NOT NULL THEN
                CASE WHEN CHARINDEX('@', i.RelationshipEmail) > 0 THEN
                        CONCAT(
                            'rel',
                            ABS(CHECKSUM(NEWID())) % 100000,
                            SUBSTRING(i.RelationshipEmail, CHARINDEX('@', i.RelationshipEmail), 4000)
                        )
                     ELSE
                        CONCAT('rel', ABS(CHECKSUM(NEWID())) % 100000, '@masked.local')
                END
            ELSE NULL
            END,

        ------------------------------------------------------------------
        -- 6) SSN & MemberNumber: random-looking, non-real
        ------------------------------------------------------------------
        SSN =
            CASE WHEN i.SSN IS NOT NULL THEN
                RIGHT(
                    '000000000' + CAST(ABS(CHECKSUM(NEWID())) % 1000000000 AS varchar(9)),
                    9
                )
            ELSE NULL
            END,
        MemberNumber =
            CASE WHEN i.MemberNumber IS NOT NULL THEN
                LEFT(
                    CONVERT(varchar(64),
                            HASHBYTES('SHA2_256', CAST(i.MemberNumber AS varchar(50))), 2),
                    LEN(i.MemberNumber)
                )
            ELSE NULL
            END
    FROM dbo.PatientTestDevMasking p
    JOIN inserted i
        ON p.PatientID = i.PatientID;   -- PK from the table definition
END;
GO
