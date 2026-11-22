
USE FootBallDH;
GO

-- =============================================
-- GOLD LAYER - DATA QUALITY CHECKS
-- =============================================


-- =============================================
-- 1. Dimension Tables Validation
-- =============================================

-- Check total and unique dates
SELECT
    COUNT(*) AS totalDates,
    COUNT(DISTINCT FullDate) AS UniqueDate
FROM Gold.DimDate;

SELECT
    COUNT(*) AS TotalDate
FROM Gold.DimDate;

SELECT TOP 10 *
FROM Gold.DimDate;


-- Check referee records
SELECT
    COUNT(*) AS TotalReferee
FROM [Gold].[DimReferee];

SELECT
    r.RefName,
    COUNT(*) AS TotalMatches
FROM Silver.footBallMatches AS m
INNER JOIN Gold.DimReferee AS r
    ON TRIM(m.referee) = r.RefName
GROUP BY r.RefName
ORDER BY TotalMatches DESC;

SELECT *
FROM Gold.DimReferee
ORDER BY TotalMatches DESC;


-- =============================================
-- 2. Fact Table Structure
-- =============================================

-- Check FactMatches column names and data types
SELECT
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'Gold'
  AND TABLE_NAME = 'FactMatches';


-- =============================================
-- 3. Team Mapping Validation
-- =============================================

-- Inspect home team mapping
SELECT
    m.HomeTeam,
    m.FTHG,
    t.TeamID
FROM Gold.DimTeam AS t
INNER JOIN Silver.footBallMatches AS m
    ON (t.TeamName) = m.HomeTeam;


-- Inspect home and away team mapping
SELECT
    m.HomeTeam,
    m.AwayTeam,
    s.TeamID,
    a.TeamID
FROM Silver.footBallMatches AS m
INNER JOIN Gold.DimTeam AS s
    ON (s.TeamName) = m.HomeTeam
INNER JOIN Gold.DimTeam AS a
    ON (m.AwayTeam) = a.TeamName;


-- =============================================
-- 4. Missing Dimension Mappings
-- =============================================

-- Check missing date mappings
SELECT
    d.DateKey,
    s.MatchDate
FROM Silver.footBallMatches AS s
LEFT JOIN Gold.DimDate AS d
    ON (s.MatchDate) = d.FullDate
WHERE d.DateKey IS NULL;


-- Check missing referee mappings
SELECT
    s.Referee,
    d.RefereeID
FROM Silver.FootBallMatches AS s
LEFT JOIN Gold.DimReferee AS d
    ON s.Referee = d.RefName
WHERE d.RefereeID IS NULL;


-- =============================================
-- 5. FactMatches Data Validation
-- =============================================

-- Check total matches
SELECT
    COUNT(*) TOTALMATCHES
FROM Gold.FactMatches;


-- Check matches with identical home and away teams
SELECT
    MatchID,
    HomeTeamID,
    AwayTeamID
FROM Gold.FactMatches
WHERE HomeTeamID = AwayTeamID;


-- Check NULL keys
SELECT
    MatchID,
    HomeTeamID,
    AwayTeamID,
    RefereeID,
    DateKey
FROM Gold.FactMatches
WHERE MatchID IS NULL
   OR RefereeID IS NULL
   OR HomeTeamID IS NULL
   OR AwayTeamID IS NULL
   OR DateKey IS NULL;


-- Check negative goals
SELECT
    MatchID,
    FTAG,
    FTHG
FROM Gold.FactMatches
WHERE FTHG < 0
   OR FTAG < 0;


-- =============================================
-- 6. Team Coverage Validation
-- =============================================

-- Find away teams not present in the home team list
SELECT DISTINCT AwayTeam
FROM Silver.FootBallMatches

EXCEPT

SELECT DISTINCT HomeTeam
FROM Silver.FootBallMatches;


-- =============================================
-- 7. Duplicate Matches Validation
-- =============================================

SELECT
    DateKey,
    HomeTeamID,
    AwayTeamID,
    Season,
    COUNT(*) AS DuplicateCount
FROM Gold.FactMatches
GROUP BY
    DateKey,
    HomeTeamID,
    AwayTeamID,
    Season
HAVING COUNT(*) > 1;


-- =============================================
-- 8. Silver vs Gold - Row Counts and Goals
-- =============================================

SELECT
    'Silver' AS DataLayer,
    COUNT(*) AS TotalMatches,
    SUM(FTHG) AS TotalHomeGoal,
    SUM(FTAG) AS TotalAwayGoal
FROM Silver.footBallMatches

UNION ALL

SELECT
    'Gold' AS DataLayer,
    COUNT(*) AS TotalMatches,
    SUM(FTHG) AS TotalHomeGoals,
    SUM(FTAG) AS TotalAwayGoals
FROM Gold.FactMatches;


-- =============================================
-- 9. Silver vs Gold - Basic Reconciliation
-- =============================================

WITH SilverData AS (
    SELECT
        d.DateKey,
        h.TeamID AS HomeTeamID,
        a.TeamID AS AwayTeamID,
        s.Season,
        s.FTHG,
        s.FTAG,
        s.FTR
    FROM Silver.FootBallMatches AS s
    INNER JOIN Gold.DimTeam AS h
        ON s.HomeTeam = h.TeamName
    INNER JOIN Gold.DimTeam AS a
        ON s.AwayTeam = a.TeamName
    INNER JOIN Gold.DimDate AS d
        ON s.MatchDate = d.FullDate
),
GoldData AS (
    SELECT
        DateKey,
        HomeTeamID,
        AwayTeamID,
        Season,
        FTHG,
        FTAG,
        FTR
    FROM Gold.FactMatches
)
SELECT *
FROM (
    SELECT * FROM SilverData
    EXCEPT
    SELECT * FROM GoldData
) AS MissingInGold

UNION ALL

SELECT *
FROM (
    SELECT * FROM GoldData
    EXCEPT
    SELECT * FROM SilverData
) AS ExtraInGold;


-- =============================================
-- 10. Silver vs Gold - Full Reconciliation
-- =============================================

WITH SilverData AS (
    SELECT
        d.DateKey,
        h.TeamID AS HomeTeamID,
        a.TeamID AS AwayTeamID,
        r.RefereeID,
        s.Season,
        s.FTHG,
        s.FTAG,
        s.FTR,
        s.HTHG,
        s.HTAG,
        s.HTR,
        s.HS,
        s.[AS],
        s.HST,
        s.AST,
        s.HF,
        s.AF,
        s.HC,
        s.AC,
        s.HY,
        s.AY,
        s.HR,
        s.AR
    FROM Silver.FootBallMatches AS s
    INNER JOIN Gold.DimTeam AS h
        ON s.HomeTeam = h.TeamName
    INNER JOIN Gold.DimTeam AS a
        ON s.AwayTeam = a.TeamName
    INNER JOIN Gold.DimDate AS d
        ON s.MatchDate = d.FullDate
    INNER JOIN Gold.DimReferee AS r
        ON s.Referee = r.RefName
),
GoldData AS (
    SELECT
        DateKey,
        HomeTeamID,
        AwayTeamID,
        RefereeID,
        Season,
        FTHG,
        FTAG,
        FTR,
        HTHG,
        HTAG,
        HTR,
        HS,
        [AS],
        HST,
        AST,
        HF,
        AF,
        HC,
        AC,
        HY,
        AY,
        HR,
        AR
    FROM Gold.FactMatches
)

SELECT 'MissingInGold' AS Issue, *
FROM (
    SELECT * FROM SilverData
    EXCEPT
    SELECT * FROM GoldData
) AS Missing

UNION ALL

SELECT 'ExtraInGold' AS Issue, *
FROM (
    SELECT * FROM GoldData
    EXCEPT
    SELECT * FROM SilverData
) AS Extra;


-- =============================================
-- 11. Optional Statistics Completeness
-- =============================================

SELECT
    COUNT(*) AS TotalMatches,
    SUM(CASE WHEN HY IS NULL OR AY IS NULL THEN 1 ELSE 0 END)
        AS MatchesWithMissingYellowCards,
    SUM(CASE WHEN HR IS NULL OR AR IS NULL THEN 1 ELSE 0 END)
        AS MatchesWithMissingRedCards,
    SUM(CASE WHEN HF IS NULL OR AF IS NULL THEN 1 ELSE 0 END)
        AS MatchesWithMissingFouls
FROM Gold.FactMatches;


-- =============================================
-- 12. Missing Home / Away Team Mappings
-- =============================================

SELECT
    s.MatchDate,
    s.HomeTeam,
    s.AwayTeam,
    s.Season
FROM Silver.FootBallMatches AS s
LEFT JOIN Gold.DimTeam AS h
    ON s.HomeTeam = h.TeamName
LEFT JOIN Gold.DimTeam AS a
    ON s.AwayTeam = a.TeamName
WHERE h.TeamID IS NULL
   OR a.TeamID IS NULL;
