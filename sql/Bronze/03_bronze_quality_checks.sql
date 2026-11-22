
USE FootBallDH;
GO

-- =============================================
-- BRONZE LAYER - DATA QUALITY CHECKS
-- =============================================


-- =============================================
-- 1. Inspect Bronze Matches
-- =============================================

SELECT *
FROM Bronze.FootBallMatches;


-- =============================================
-- 2. Inspect Bronze Table Structure
-- =============================================

SELECT
    COLUMN_NAME,
    DATA_TYPE,
    ORDINAL_POSITION
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'bronze'
  AND TABLE_NAME = 'footballMatches'
ORDER BY ORDINAL_POSITION;


-- =============================================
-- 3. Check Landing Table Record Count
-- =============================================

SELECT COUNT(*) AS TotalRows
FROM Bronze.FootBallMatches_Landing;


-- =============================================
-- 4. Inspect Landing Table Sample
-- =============================================

SELECT TOP 10 *
FROM Bronze.FootBallMatches_Landing;


-- =============================================
-- 5. Validate Landing Dates
-- =============================================

SELECT *
FROM Bronze.FootBallMatches_Landing
WHERE TRY_CONVERT(DATE, [Date], 23) IS NULL;


-- =============================================
-- 6. Validate Key Numeric Fields
-- =============================================

SELECT *
FROM Bronze.FootBallMatches_Landing
WHERE TRY_CONVERT(INT, FTHG) IS NULL
   OR TRY_CONVERT(INT, FTAG) IS NULL
   OR TRY_CONVERT(INT, HS) IS NULL;


-- =============================================
-- 7. Validate Additional Numeric Fields
-- =============================================

SELECT *
FROM Bronze.FootBallMatches_Landing
WHERE TRY_CONVERT(INT, HF) IS NULL
   OR TRY_CONVERT(INT, [AS]) IS NULL
   OR TRY_CONVERT(INT, HY) IS NULL
   OR TRY_CONVERT(INT, HR) IS NULL
   OR TRY_CONVERT(INT, AR) IS NULL
   OR TRY_CONVERT(INT, HST) IS NULL
   OR TRY_CONVERT(INT, AY) IS NULL
   OR TRY_CONVERT(INT, AST) IS NULL
   OR TRY_CONVERT(INT, HTHG) IS NULL
   OR TRY_CONVERT(INT, HTAG) IS NULL
   OR TRY_CONVERT(INT, AF) IS NULL
   OR TRY_CONVERT(INT, HC) IS NULL
   OR TRY_CONVERT(INT, AC) IS NULL;


-- =============================================
-- 8. Inspect Landing Table Structure
-- =============================================

SELECT
    COLUMN_NAME,
    DATA_TYPE,
    ORDINAL_POSITION
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'bronze'
  AND TABLE_NAME = 'FootBallMatches_Landing'
ORDER BY ORDINAL_POSITION;


-- =============================================
-- 9. Compare Bronze Table Structures
-- =============================================

SELECT
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    ORDINAL_POSITION
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'Bronze'
  AND TABLE_NAME IN (
      'FootBallMatches_Landing',
      'FootBallMatches'
  )
ORDER BY TABLE_NAME, ORDINAL_POSITION;


-- =============================================
-- 10. Count Matches by Season
-- =============================================

SELECT
    Season,
    COUNT(*) AS TotalMatches
FROM Bronze.FootBallMatches
GROUP BY Season;


-- =============================================
-- 11. Validate 2021/22 Season
-- =============================================

SELECT
    COUNT(*) AS TotalRows,
    COUNT(MatchDate) AS ValidDates,
    COUNT(FTHG) AS ValidHomeGoales,
    COUNT(FTAG) AS ValidAwayGoals
FROM Bronze.FootBallMatches
WHERE Season = '2021/22';


-- =============================================
-- 12. Validate Landing Data for 2022/23
-- =============================================

SELECT *
FROM Bronze.FootBallMatches_Landing
WHERE TRY_CONVERT(DATE, [Date], 23) IS NULL
   OR TRY_CONVERT(INT, FTHG) IS NULL
   OR TRY_CONVERT(INT, FTAG) IS NULL
   OR TRY_CONVERT(INT, HTHG) IS NULL
   OR TRY_CONVERT(INT, HTAG) IS NULL
   OR TRY_CONVERT(INT, HS) IS NULL
   OR TRY_CONVERT(INT, [AS]) IS NULL
   OR TRY_CONVERT(INT, HST) IS NULL
   OR TRY_CONVERT(INT, AST) IS NULL
   OR TRY_CONVERT(INT, HF) IS NULL
   OR TRY_CONVERT(INT, AF) IS NULL
   OR TRY_CONVERT(INT, HC) IS NULL
   OR TRY_CONVERT(INT, AC) IS NULL
   OR TRY_CONVERT(INT, HY) IS NULL
   OR TRY_CONVERT(INT, AY) IS NULL
   OR TRY_CONVERT(INT, HR) IS NULL
   OR TRY_CONVERT(INT, AR) IS NULL;


-- =============================================
-- 13. Validate Matches Across Seasons
-- =============================================

SELECT
    Season,
    COUNT(*) AS TotalMatches,
    COUNT(MatchDate) AS ValidDates,
    COUNT(FTHG) AS ValidHomeGoals,
    COUNT(FTAG) AS ValidAwayGoals
FROM Bronze.FootBallMatches
GROUP BY Season
ORDER BY Season;


-- Original validation query used for later seasons

SELECT
    Season,
    COUNT(*) AS TotalMatches,
    COUNT(MatchDate) AS ValidDate,
    COUNT(FTHG) AS ValidGoalsHome,
    COUNT(FTAG) AS ValidGoalsAway
FROM Bronze.FootBallMatches
GROUP BY Season
ORDER BY Season;


-- =============================================
-- 14. Check Duplicate Matches
-- =============================================

SELECT
    Season,
    HomeTeam,
    AwayTeam,
    MatchDate,
    COUNT(*) AS DuplicateCount
FROM Bronze.FootBallMatches
GROUP BY
    Season,
    HomeTeam,
    AwayTeam,
    MatchDate
HAVING COUNT(*) > 1;


-- =============================================
-- 15. Check Negative Goal Values
-- =============================================

SELECT *
FROM Bronze.FootBallMatches
WHERE FTAG < 0
   OR FTHG < 0
   OR HTHG < 0
   OR HTAG < 0;


-- =============================================
-- 16. Validate Full-Time Results
-- =============================================

SELECT *
FROM Bronze.FootBallMatches
WHERE (FTR = 'H' AND FTHG <= FTAG)
   OR (FTR = 'A' AND FTAG <= FTHG)
   OR (FTR = 'D' AND FTAG != FTHG)
   OR FTR IS NULL
   OR FTR NOT IN ('H', 'A', 'D');


-- =============================================
-- 17. Validate Shots on Target
-- =============================================

SELECT *
FROM Bronze.FootBallMatches
WHERE HST > HS
   OR AST > [AS];


/*
Data Quality Issue #001

Season: 2021/22
Match: Newcastle vs West Ham
Date: 2021-08-15

Issue:
Away Shots (AS) = 8
Away Shots on Target (AST) = 9

Rule Violated:
AST <= AS

Status at discovery: Pending Investigation

Action:
Keep original values in Bronze.
Verify against a trusted source before correction.

The correction was later handled in Silver.
*/


-- =============================================
-- 18. Check Missing Values
-- =============================================

SELECT
    COUNT(*) AS TotalMatches,
    SUM(CASE WHEN HomeTeam IS NULL OR TRIM(HomeTeam) = ''
        THEN 1 ELSE 0 END) AS MissingHomeTeam,
    SUM(CASE WHEN AwayTeam IS NULL OR TRIM(AwayTeam) = ''
        THEN 1 ELSE 0 END) AS MissingAwayTeam,
    SUM(CASE WHEN Referee IS NULL OR TRIM(Referee) = ''
        THEN 1 ELSE 0 END) AS MissingReferee,
    SUM(CASE WHEN HS IS NULL
        THEN 1 ELSE 0 END) AS MissingHomeShots,
    SUM(CASE WHEN [AS] IS NULL
        THEN 1 ELSE 0 END) AS MissingAwayShots,
    SUM(CASE WHEN HST IS NULL
        THEN 1 ELSE 0 END) AS MissingHomeShotsOnTarget,
    SUM(CASE WHEN AST IS NULL
        THEN 1 ELSE 0 END) AS MissingAwayShotsOnTarget
FROM Bronze.FootBallMatches;


-- =============================================
-- 19. Validate Half-Time Results
-- =============================================

-- HTHG: Home Team Half-Time Goals
-- HTAG: Away Team Half-Time Goals
-- HTR: Half-Time Result (H, A, D)

SELECT *
FROM Bronze.FootBallMatches
WHERE (HTHG > HTAG AND HTR IN ('A', 'D'))
   OR (HTHG < HTAG AND HTR IN ('H', 'D'))
   OR (HTHG = HTAG AND HTR IN ('H', 'A'))
   OR HTR IS NULL
   OR HTR NOT IN ('H', 'A', 'D');
