
/*
Project: Football Data Warehouse
Layer: Silver
File: 01_create_silver_tables.sql

Purpose:
Create Silver layer tables for cleaned
and validated football match data.
*/

-- =============================================
-- 1. Create Silver Football Matches Table
-- =============================================

SELECT TOP (0) *
INTO Silver.FootBallMatches
FROM Bronze.FootBallMatches;


-- =============================================
-- 2. Add Data Quality Status
-- =============================================

ALTER TABLE Silver.FootBallMatches
ADD DataQualityStatus NVARCHAR(20) NOT NULL
CONSTRAINT CHK_FootBallMatches_DataQualityStatus
CHECK (
    DataQualityStatus IN ('Valid', 'Corrected', 'NeedsReview')
);


-- =============================================
-- 3. Load Football Matches from Bronze
-- =============================================

INSERT INTO Silver.FootBallMatches (
    MatchDate, HomeTeam, AwayTeam,
    FTHG, FTAG, FTR,
    HTHG, HTAG, HTR,
    Referee, HS, [AS], HST, AST,
    HF, AF, HC, AC,
    HY, AY, HR, AR,
    Season, DataQualityStatus
)
SELECT
    MatchDate, HomeTeam, AwayTeam,
    FTHG, FTAG, FTR,
    HTHG, HTAG, HTR,
    Referee, HS, [AS], HST, AST,
    HF, AF, HC, AC,
    HY, AY, HR, AR,
    Season, 'Valid'
FROM Bronze.FootBallMatches;


-- =============================================
-- 4. Create Data Quality Issues Table
-- =============================================

CREATE TABLE Silver.DataQualityIssues
(
    IssueID INT IDENTITY(1,1) PRIMARY KEY,

    MatchDate DATE NOT NULL,
    HomeTeam NVARCHAR(100) NOT NULL,
    AwayTeam NVARCHAR(100) NOT NULL,
    Season NVARCHAR(10) NOT NULL,

    ColumnName NVARCHAR(50) NOT NULL,
    OriginalValue NVARCHAR(100),
    CorrectedValue NVARCHAR(100),

    IssueDescription NVARCHAR(500) NOT NULL,
    CorrectionSource NVARCHAR(500),

    IssueStatus NVARCHAR(20) NOT NULL
        CONSTRAINT CHK_DataQualityIssues_Status
        CHECK (IssueStatus IN ('Open', 'Resolved')),

    LoggedAt DATETIME2 NOT NULL
        DEFAULT SYSDATETIME()
);


-- =============================================
-- 5. Inspect Data Quality Issues Structure
-- =============================================

SELECT TOP (0) *
FROM Silver.DataQualityIssues;


-- =============================================
-- 6. Log Resolved Data Quality Issue
-- =============================================

USE FootBallDH;
GO

INSERT INTO Silver.DataQualityIssues
(
    MatchDate,
    HomeTeam,
    AwayTeam,
    Season,
    ColumnName,
    OriginalValue,
    CorrectedValue,
    IssueDescription,
    CorrectionSource,
    IssueStatus
)
VALUES
(
    '2021-08-15',
    'Newcastle',
    'West Ham',
    '2021/22',
    'AS',
    '8',
    '18',
    'Away shots on target exceeded total away shots.',
    'FotMob - Newcastle vs West Ham, 2021-08-15',
    'Resolved'
);


-- =============================================
-- 7. Review Logged Data Quality Issues
-- =============================================

SELECT *
FROM Silver.DataQualityIssues;
