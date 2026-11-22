
USE FootBallDH;
GO

-- =============================================
-- SILVER LAYER - DATA TRANSFORMATION
-- =============================================


-- =============================================
-- 1. Correct Away Team Shots
-- =============================================

UPDATE Silver.footBallMatches
SET
    [AS] = 18,
    DataQualityStatus = 'Corrected'
WHERE HomeTeam = 'NewCastle'
  AND AwayTeam = 'West Ham'
  AND MatchDate = '2021-08-15'
  AND Season = '2021/22'
  AND [AS] = 8;


-- =============================================
-- 2. Verify Corrected Match
-- =============================================

SELECT *
FROM Silver.footBallMatches
WHERE HomeTeam = 'NewCastle'
  AND AwayTeam = 'West Ham'
  AND MatchDate = '2021-08-15';


-- =============================================
-- 3. Count Matches by Data Quality Status
-- =============================================

SELECT
    DataQualityStatus,
    COUNT(*) AS TotalMatches
FROM Silver.footballMatches
GROUP BY DataQualityStatus;


-- =============================================
-- 4. Validate Shots and Shots on Target
-- =============================================

SELECT *
FROM Silver.FootBallMatches
WHERE HS < HST
   OR AST > [AS];
