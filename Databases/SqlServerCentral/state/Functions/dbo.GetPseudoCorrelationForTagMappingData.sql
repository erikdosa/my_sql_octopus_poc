SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetPseudoCorrelationForTagMappingData] 
(	
	@tag1ID int, 
	@tag2ID int
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT SUM((tmmmd1.NumMappings - tmmmd1.MeanNumMappings) * (tmmmd2.NumMappings - tmmmd2.MeanNumMappings)) / STDEV(tmmmd2.NumMappings) as PseudoCorr
	FROM GetTagMappingsWithMeanData(@tag1ID) tmmmd1
	JOIN (SELECT * FROM GetTagMappingsWithMeanData(@tag2ID)) AS tmmmd2 ON [tmmmd2].ContentItemID=[tmmmd1].ContentItemID
)


GO
