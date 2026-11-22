
USE FootBallDH;
GO

-- =============================================
-- GOLD LAYER - ANALYTICAL QUERIES
-- =============================================


-- =============================================
-- 1. Home Team Performance
-- =============================================

SELECT
    t.TeamName,
    f.Season,
    COUNT(*) AS HomeMatches,
    SUM(CASE WHEN f.FTR = 'H' THEN 1 ELSE 0 END) AS HomeWins,
    SUM(CASE WHEN f.FTR = 'D' THEN 1 ELSE 0 END) AS HomeDraws,
    SUM(CASE WHEN f.FTR = 'A' THEN 1 ELSE 0 END) AS HomeLosses,
    SUM(f.FTHG) AS HomeGoalsScored,
    SUM(f.FTAG) AS HomeGoalsConceded
FROM Gold.FactMatches AS f
INNER JOIN Gold.DimTeam AS t
    ON f.HomeTeamID = t.TeamID
GROUP BY
    t.TeamName,
    f.Season
ORDER BY
    f.Season,
    t.TeamName;


-- =============================================
-- 2. Away Team Performance
-- =============================================

SELECT
    t.TeamName,
    f.Season,
    COUNT(*) AS AwayMatches,
    SUM(CASE WHEN f.FTR = 'A' THEN 1 ELSE 0 END) AS AwayWins,
    SUM(CASE WHEN f.FTR = 'D' THEN 1 ELSE 0 END) AS AwayDraws,
    SUM(CASE WHEN f.FTR = 'H' THEN 1 ELSE 0 END) AS AwayLosses,
    SUM(f.FTAG) AS AwayGoalsScored,
    SUM(f.FTHG) AS AwayGoalsConceded
FROM Gold.FactMatches AS f
INNER JOIN Gold.DimTeam AS t
    ON f.AwayTeamID = t.TeamID
GROUP BY
    t.TeamName,
    f.Season
ORDER BY
    f.Season,
    t.TeamName;


-- =============================================
-- 3. League Standings Analysis
-- =============================================

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
    ON s.TeamID = t.TeamID
ORDER BY
    s.Season,
    LeaguePosition,
    t.TeamName;
