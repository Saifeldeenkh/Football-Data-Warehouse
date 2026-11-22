
USE FootBallDH;
GO

-- =============================================
-- BRONZE LAYER - TABLE CREATION
-- =============================================

-- 1. Create the main Bronze matches table

CREATE TABLE Bronze.FootBallMatches
(
    MatchDate DATE,
    HomeTeam NVARCHAR(100),
    AwayTeam NVARCHAR(100),
    FTHG INT,
    FTAG INT,
    FTR NVARCHAR(5),
    HTHG INT,
    HTAG INT,
    HTR NVARCHAR(5),
    Referee NVARCHAR(100),
    HS INT,
    [AS] INT,
    HST INT,
    AST INT,
    HF INT,
    AF INT,
    HC INT,
    AC INT,
    HY INT,
    AY INT,
    HR INT,
    AR INT,
    Season NVARCHAR(10)
);


-- 2. Create the Landing table for raw CSV ingestion

CREATE TABLE Bronze.FootBallMatches_Landing
(
    [Date] NVARCHAR(50),
    HomeTeam NVARCHAR(100),
    AwayTeam NVARCHAR(100),
    FTHG NVARCHAR(50),
    FTAG NVARCHAR(50),
    FTR NVARCHAR(5),
    HTHG NVARCHAR(50),
    HTAG NVARCHAR(50),
    HTR NVARCHAR(5),
    Referee NVARCHAR(100),
    HS NVARCHAR(50),
    [AS] NVARCHAR(50),
    HST NVARCHAR(50),
    AST NVARCHAR(50),
    HF NVARCHAR(50),
    AF NVARCHAR(50),
    HC NVARCHAR(50),
    AC NVARCHAR(50),
    HY NVARCHAR(50),
    AY NVARCHAR(50),
    HR NVARCHAR(50),
    AR NVARCHAR(50)
);
