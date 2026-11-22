
USE FootBallDH;
GO

-- =============================================
-- GOLD LAYER - ANALYTICAL VIEWS
-- =============================================


-- =============================================
-- 1. League Standings
-- =============================================

CREATE OR ALTER VIEW Gold.vw_LeagueStandings
AS

WITH TeamMatches AS (

    -- Home Matches
    SELECT
        f.Season,
        f.HomeTeamID AS TeamID,
        f.FTHG AS GoalsFor,
        f.FTAG AS GoalsAgainst,
        CASE WHEN f.FTR = 'H' THEN 1 ELSE 0 END AS Won,
        CASE WHEN f.FTR = 'D' THEN 1 ELSE 0 END AS Drawn,
        CASE WHEN f.FTR = 'A' THEN 1 ELSE 0 END AS Lost
    FROM Gold.FactMatches AS f

    UNION ALL

    -- Away Matches
    SELECT
        f.Season,
        f.AwayTeamID AS TeamID,
        f.FTAG AS GoalsFor,
        f.FTHG AS GoalsAgainst,
        CASE WHEN f.FTR = 'A' THEN 1 ELSE 0 END AS Won,
        CASE WHEN f.FTR = 'D' THEN 1 ELSE 0 END AS Drawn,
        CASE WHEN f.FTR = 'H' THEN 1 ELSE 0 END AS Lost
    FROM Gold.FactMatches AS f
),

TeamStats AS (
    SELECT
        Season,
        TeamID,
        COUNT(*) AS Played,
        SUM(Won) AS Won,
        SUM(Drawn) AS Drawn,
        SUM(Lost) AS Lost,
        SUM(GoalsFor) AS GoalsFor,
        SUM(GoalsAgainst) AS GoalsAgainst,
        SUM(GoalsFor) - SUM(GoalsAgainst) AS GoalDifference,
        SUM(Won) * 3 + SUM(Drawn) AS Points
    FROM TeamMatches
    GROUP BY Season, TeamID
)

SELECT
    RANK() OVER (
        PARTITION BY s.Season
        ORDER BY
            s.Points DESC,
            s.GoalDifference DESC,
            s.GoalsFor DESC
    ) AS LeaguePosition,
    s.Season,
    t.TeamName,
    s.Played,
    s.Won,
    s.Drawn,
    s.Lost,
    s.GoalsFor,
    s.GoalsAgainst,
    s.GoalDifference,
    s.Points
FROM TeamStats AS s
INNER JOIN Gold.DimTeam AS t
    ON s.TeamID = t.TeamID;



-- =============================================
-- 2. Home vs Away Performance
-- =============================================

CREATE OR ALTER VIEW Gold.vw_HomeAwayPerformance
AS

-- Home Performance
SELECT
    f.Season,
    t.TeamName,
    COUNT(*) AS MatchesPlayed,
    SUM(CASE WHEN f.FTR = 'H' THEN 1 ELSE 0 END) AS Wins,
    SUM(CASE WHEN f.FTR = 'D' THEN 1 ELSE 0 END) AS Draws,
    SUM(CASE WHEN f.FTR = 'A' THEN 1 ELSE 0 END) AS Losses,
    SUM(f.FTHG) AS GoalsScored,
    SUM(f.FTAG) AS GoalsConceded,
    'Home' AS Venue
FROM Gold.FactMatches AS f
INNER JOIN Gold.DimTeam AS t
    ON f.HomeTeamID = t.TeamID
GROUP BY f.Season, t.TeamName

UNION ALL

-- Away Performance
SELECT
    f.Season,
    t.TeamName,
    COUNT(*) AS MatchesPlayed,
    SUM(CASE WHEN f.FTR = 'A' THEN 1 ELSE 0 END) AS Wins,
    SUM(CASE WHEN f.FTR = 'D' THEN 1 ELSE 0 END) AS Draws,
    SUM(CASE WHEN f.FTR = 'H' THEN 1 ELSE 0 END) AS Losses,
    SUM(f.FTAG) AS GoalsScored,
    SUM(f.FTHG) AS GoalsConceded,
    'Away' AS Venue
FROM Gold.FactMatches AS f
INNER JOIN Gold.DimTeam AS t
    ON f.AwayTeamID = t.TeamID
GROUP BY f.Season, t.TeamName;



-- =============================================
-- 3. Referee Statistics
-- =============================================

CREATE OR ALTER VIEW Gold.vw_RefereeStats
AS

SELECT
    r.RefereeID,
    r.RefName,
    COUNT(*) AS TotalMatches,
    SUM(f.HY + f.AY) AS TotalYellowCards,
    SUM(f.HR + f.AR) AS TotalRedCards,
    SUM(f.HF + f.AF) AS TotalFouls,
    CAST(
        AVG(CAST(f.HY + f.AY AS FLOAT))
        AS DECIMAL(10,2)
    ) AS AvgYellowCardsPerMatch
FROM Gold.FactMatches AS f
INNER JOIN Gold.DimReferee AS r
    ON f.RefereeID = r.RefereeID
GROUP BY
    r.RefereeID,
    r.RefName;



-- =============================================
-- 4. View Results - Sample Queries
-- =============================================

SELECT *
FROM Gold.vw_LeagueStandings
WHERE Season = '2022/23'
ORDER BY LeaguePosition, TeamName;


SELECT *
FROM Gold.vw_HomeAwayPerformance
WHERE Season = '2022/23'
ORDER BY TeamName, Venue;


SELECT *
FROM Gold.vw_RefereeStats
ORDER BY TotalMatches DESC;
