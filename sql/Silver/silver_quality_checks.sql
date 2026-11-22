
USE FootBallDH;
GO

-- =============================================
-- SILVER LAYER - DATA QUALITY CHECKS
-- =============================================

-- Compare Bronze and Silver record counts
-- and track corrected matches and resolved issues

SELECT
    (SELECT COUNT(*)
     FROM Bronze.FootBallMatches) AS BronzeCount,

    (SELECT COUNT(*)
     FROM Silver.FootBallMatches) AS SilverCount,

    (SELECT COUNT(*)
     FROM Silver.FootBallMatches
     WHERE DataQualityStatus = 'Corrected') AS CorrectedCount,

    (SELECT COUNT(*)
     FROM Silver.DataQualityIssues
     WHERE IssueStatus = 'Resolved') AS ResolvedIssues;
