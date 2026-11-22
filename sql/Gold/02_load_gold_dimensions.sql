
USE FootBallDH;
GO

-- ==========================================
-- 1. Load DimTeam
-- ==========================================

INSERT INTO Gold.DimTeam (TeamName)
SELECT DISTINCT HomeTeam
FROM Silver.FootBallMatches;


-- ==========================================
-- 2. Load DimDate
-- ==========================================

INSERT INTO Gold.DimDate
(
    DateKey,
    FullDate,
    [Year],
    [Month],
    MonthName,
    [Day],
    DayName
)
SELECT DISTINCT
    CONVERT(INT, CONVERT(CHAR(8), MatchDate, 112)),
    MatchDate,
    YEAR(MatchDate),
    MONTH(MatchDate),
    DATENAME(MONTH, MatchDate),
    DAY(MatchDate),
    DATENAME(WEEKDAY, MatchDate)
FROM Silver.FootBallMatches
WHERE MatchDate IS NOT NULL;


-- ==========================================
-- 3. Load DimReferee
-- ==========================================

INSERT INTO Gold.DimReferee (RefName)
SELECT DISTINCT TRIM(Referee)
FROM Silver.FootBallMatches
WHERE Referee IS NOT NULL
  AND TRIM(Referee) <> '';


-- ==========================================
-- 4. Update Referee Total Matches
-- ==========================================

UPDATE r
SET r.TotalMatches =
(
    SELECT COUNT(*)
    FROM Silver.FootBallMatches AS m
    WHERE TRIM(m.Referee) = r.RefName
)
FROM Gold.DimReferee AS r;
