USE FootBallDH;
GO

-- =============================================
-- GOLD LAYER - TABLE CREATION
-- =============================================


-- =============================================
-- 1. Create DimTeam
-- =============================================

CREATE TABLE Gold.DimTeam
(
    TeamID INT IDENTITY(1,1) PRIMARY KEY,
    TeamName NVARCHAR(100) NOT NULL UNIQUE
);
GO


-- =============================================
-- 2. Create DimDate
-- =============================================

CREATE TABLE Gold.DimDate
(
    DateKey INT PRIMARY KEY,
    FullDate DATE NOT NULL UNIQUE,
    [Year] INT NOT NULL,
    [Month] INT NOT NULL,
    MonthName NVARCHAR(20) NOT NULL,
    [Day] INT NOT NULL,
    DayName NVARCHAR(20) NOT NULL
);
GO


-- =============================================
-- 3. Create DimReferee
-- =============================================

CREATE TABLE Gold.DimReferee
(
    RefereeID INT IDENTITY(1,1) PRIMARY KEY,
    RefName NVARCHAR(100) NOT NULL UNIQUE,
    TotalMatches INT NOT NULL DEFAULT 0
);
GO


-- =============================================
-- 4. Create FactMatches
-- =============================================

CREATE TABLE Gold.FactMatches
(
    MatchID INT IDENTITY(1,1) PRIMARY KEY,

    DateKey INT NOT NULL,
    HomeTeamID INT NOT NULL,
    AwayTeamID INT NOT NULL,
    RefereeID INT NOT NULL,

    Season NVARCHAR(20) NOT NULL,

    FTHG INT NOT NULL,
    FTAG INT NOT NULL,
    FTR CHAR(1) NOT NULL,

    HTHG INT NULL,
    HTAG INT NULL,
    HTR CHAR(1) NULL,

    HS INT NULL,
    [AS] INT NULL,
    HST INT NULL,
    AST INT NULL,

    HF INT NULL,
    AF INT NULL,

    HC INT NULL,
    AC INT NULL,

    HY INT NULL,
    AY INT NULL,

    HR INT NULL,
    AR INT NULL,

    CONSTRAINT CK_DifferentTeams
        CHECK (HomeTeamID <> AwayTeamID)
);
GO


-- =============================================
-- 5. Create Foreign Key Relationships
-- =============================================

ALTER TABLE Gold.FactMatches
ADD CONSTRAINT FK_FactMatches_HomeTeam
FOREIGN KEY (HomeTeamID)
REFERENCES Gold.DimTeam(TeamID);
GO

ALTER TABLE Gold.FactMatches
ADD CONSTRAINT FK_FactMatches_AwayTeam
FOREIGN KEY (AwayTeamID)
REFERENCES Gold.DimTeam(TeamID);
GO

ALTER TABLE Gold.FactMatches
ADD CONSTRAINT FK_FactMatches_Date
FOREIGN KEY (DateKey)
REFERENCES Gold.DimDate(DateKey);
GO

ALTER TABLE Gold.FactMatches
ADD CONSTRAINT FK_FactMatches_Ref
FOREIGN KEY (RefereeID)
REFERENCES Gold.DimReferee(RefereeID);
GO
