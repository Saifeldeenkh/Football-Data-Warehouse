
USE FootBallDH;
GO

-- =============================================
-- BRONZE LAYER - DATA INGESTION
-- =============================================

-- =============================================
-- 1. SEASON 2021/22
-- =============================================

BULK INSERT Bronze.FootBallMatches_Landing
FROM 'C:\Users\Saif Obito\Downloads\season-2122.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);

INSERT INTO Bronze.FootBallMatches
(
    MatchDate, HomeTeam, AwayTeam,
    FTHG, FTAG, FTR,
    HTHG, HTAG, HTR,
    Referee, HS, [AS], HST, AST,
    HF, AF, HC, AC,
    HY, AY, HR, AR, Season
)
SELECT
    TRY_CONVERT(DATE, [Date], 23),
    HomeTeam,
    AwayTeam,
    TRY_CONVERT(INT, FTHG),
    TRY_CONVERT(INT, FTAG),
    FTR,
    TRY_CONVERT(INT, HTHG),
    TRY_CONVERT(INT, HTAG),
    HTR,
    Referee,
    TRY_CONVERT(INT, HS),
    TRY_CONVERT(INT, [AS]),
    TRY_CONVERT(INT, HST),
    TRY_CONVERT(INT, AST),
    TRY_CONVERT(INT, HF),
    TRY_CONVERT(INT, AF),
    TRY_CONVERT(INT, HC),
    TRY_CONVERT(INT, AC),
    TRY_CONVERT(INT, HY),
    TRY_CONVERT(INT, AY),
    TRY_CONVERT(INT, HR),
    TRY_CONVERT(INT, AR),
    '2021/22'
FROM Bronze.FootBallMatches_Landing;


-- =============================================
-- 2. SEASON 2022/23
-- =============================================

TRUNCATE TABLE Bronze.FootBallMatches_Landing;

BULK INSERT Bronze.FootBallMatches_Landing
FROM 'C:\Users\Saif Obito\Downloads\season-2223.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);

INSERT INTO Bronze.FootBallMatches
(
    MatchDate, HomeTeam, AwayTeam,
    FTHG, FTAG, FTR,
    HTHG, HTAG, HTR,
    Referee, HS, [AS], HST, AST,
    HF, AF, HC, AC,
    HY, AY, HR, AR, Season
)
SELECT
    TRY_CONVERT(DATE, [Date], 23),
    HomeTeam,
    AwayTeam,
    TRY_CONVERT(INT, FTHG),
    TRY_CONVERT(INT, FTAG),
    FTR,
    TRY_CONVERT(INT, HTHG),
    TRY_CONVERT(INT, HTAG),
    HTR,
    Referee,
    TRY_CONVERT(INT, HS),
    TRY_CONVERT(INT, [AS]),
    TRY_CONVERT(INT, HST),
    TRY_CONVERT(INT, AST),
    TRY_CONVERT(INT, HF),
    TRY_CONVERT(INT, AF),
    TRY_CONVERT(INT, HC),
    TRY_CONVERT(INT, AC),
    TRY_CONVERT(INT, HY),
    TRY_CONVERT(INT, AY),
    TRY_CONVERT(INT, HR),
    TRY_CONVERT(INT, AR),
    '2022/23'
FROM Bronze.FootBallMatches_Landing;


-- =============================================
-- 3. SEASON 2023/24
-- =============================================

TRUNCATE TABLE Bronze.FootBallMatches_Landing;

BULK INSERT Bronze.FootBallMatches_Landing
FROM 'C:\Users\Saif Obito\Downloads\season-2324.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);

INSERT INTO Bronze.FootBallMatches
(
    MatchDate, HomeTeam, AwayTeam,
    FTHG, FTAG, FTR,
    HTHG, HTAG, HTR,
    Referee, HS, [AS], HST, AST,
    HF, AF, HC, AC,
    HY, AY, HR, AR, Season
)
SELECT
    TRY_CONVERT(DATE, [Date], 23),
    HomeTeam,
    AwayTeam,
    TRY_CONVERT(INT, FTHG),
    TRY_CONVERT(INT, FTAG),
    FTR,
    TRY_CONVERT(INT, HTHG),
    TRY_CONVERT(INT, HTAG),
    HTR,
    Referee,
    TRY_CONVERT(INT, HS),
    TRY_CONVERT(INT, [AS]),
    TRY_CONVERT(INT, HST),
    TRY_CONVERT(INT, AST),
    TRY_CONVERT(INT, HF),
    TRY_CONVERT(INT, AF),
    TRY_CONVERT(INT, HC),
    TRY_CONVERT(INT, AC),
    TRY_CONVERT(INT, HY),
    TRY_CONVERT(INT, AY),
    TRY_CONVERT(INT, HR),
    TRY_CONVERT(INT, AR),
    '2023/24'
FROM Bronze.FootBallMatches_Landing;


-- =============================================
-- 4. SEASON 2024/25
-- =============================================

TRUNCATE TABLE Bronze.FootBallMatches_Landing;

BULK INSERT Bronze.FootBallMatches_Landing
FROM 'C:\Users\Saif Obito\Downloads\season-2425.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);

INSERT INTO Bronze.FootBallMatches
(
    MatchDate, HomeTeam, AwayTeam,
    FTHG, FTAG, FTR,
    HTHG, HTAG, HTR,
    Referee, HS, [AS], HST, AST,
    HF, AF, HC, AC,
    HY, AY, HR, AR, Season
)
SELECT
    TRY_CONVERT(DATE, [Date], 23),
    HomeTeam,
    AwayTeam,
    TRY_CONVERT(INT, FTHG),
    TRY_CONVERT(INT, FTAG),
    FTR,
    TRY_CONVERT(INT, HTHG),
    TRY_CONVERT(INT, HTAG),
    HTR,
    Referee,
    TRY_CONVERT(INT, HS),
    TRY_CONVERT(INT, [AS]),
    TRY_CONVERT(INT, HST),
    TRY_CONVERT(INT, AST),
    TRY_CONVERT(INT, HF),
    TRY_CONVERT(INT, AF),
    TRY_CONVERT(INT, HC),
    TRY_CONVERT(INT, AC),
    TRY_CONVERT(INT, HY),
    TRY_CONVERT(INT, AY),
    TRY_CONVERT(INT, HR),
    TRY_CONVERT(INT, AR),
    '2024/25'
FROM Bronze.FootBallMatches_Landing;


-- =============================================
-- 5. SEASON 2025/26
-- =============================================

TRUNCATE TABLE Bronze.FootBallMatches_Landing;

BULK INSERT Bronze.FootBallMatches_Landing
FROM 'C:\Users\Saif Obito\Downloads\season-2526.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);

INSERT INTO Bronze.FootBallMatches
(
    MatchDate, HomeTeam, AwayTeam,
    FTHG, FTAG, FTR,
    HTHG, HTAG, HTR,
    Referee, HS, [AS], HST, AST,
    HF, AF, HC, AC,
    HY, AY, HR, AR, Season
)
SELECT
    TRY_CONVERT(DATE, [Date], 23),
    HomeTeam,
    AwayTeam,
    TRY_CONVERT(INT, FTHG),
    TRY_CONVERT(INT, FTAG),
    FTR,
    TRY_CONVERT(INT, HTHG),
    TRY_CONVERT(INT, HTAG),
    HTR,
    Referee,
    TRY_CONVERT(INT, HS),
    TRY_CONVERT(INT, [AS]),
    TRY_CONVERT(INT, HST),
    TRY_CONVERT(INT, AST),
    TRY_CONVERT(INT, HF),
    TRY_CONVERT(INT, AF),
    TRY_CONVERT(INT, HC),
    TRY_CONVERT(INT, AC),
    TRY_CONVERT(INT, HY),
    TRY_CONVERT(INT, AY),
    TRY_CONVERT(INT, HR),
    TRY_CONVERT(INT, AR),
    '2025/26'
FROM Bronze.FootBallMatches_Landing;
