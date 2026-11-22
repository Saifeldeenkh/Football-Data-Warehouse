
USE FootBallDH;
GO

-- ==========================================
-- Load Gold FactMatches
-- ==========================================

INSERT INTO Gold.FactMatches
(
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
)
SELECT
    d.DateKey,
    h.TeamID,
    a.TeamID,
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
    ON TRIM(s.Referee) = r.RefName;



SELECT
    d.DateKey,
    h.TeamID AS HomeTeamID,
    a.TeamID AS AwayTeamID,
    r.RefereeID,
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

INNER JOIN Gold.DimReferee AS r
    ON s.Referee = r.RefName;

    SELECT COUNT(*) AS ReadyMatches
FROM Silver.FootBallMatches AS s

INNER JOIN Gold.DimTeam AS h
    ON s.HomeTeam = h.TeamName

INNER JOIN Gold.DimTeam AS a
    ON s.AwayTeam = a.TeamName

INNER JOIN Gold.DimDate AS d
    ON s.MatchDate = d.FullDate

INNER JOIN Gold.DimReferee AS r
    ON s.Referee = r.RefName;

