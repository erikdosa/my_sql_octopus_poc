SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetMostSiteCorrelatedContentItems] 
	@ContentItemID int = 0,
	@MaxResults int = 5,
	@Threshold float = 0.3
AS
BEGIN
	SELECT TOP (@MaxResults) correlationData.Y_id as ContentItemID FROM (
		SELECT ci.[ContentItemID] AS Y_id, 
			(COUNT(t.[TagID]) - [stats1].[NumTags]*stats1.[AvgNumMappings]*[stats2].[AvgNumMappings]) / (stats1.[StDevNumMappings] * stats2.[StDevNumMappings] * ([stats1].[NumTags] - 1)) AS Correlation
		FROM Tags t
		CROSS JOIN [ContentItems] ci
		JOIN [TagMappings] tm1 ON tm1.[ContentItemID] = @ContentItemID AND tm1.[TagID] = t.[TagID]
		JOIN [TagMappings] tm2 ON tm2.[ContentItemID] = ci.[ContentItemID] AND tm2.[TagID] = t.[TagID]
		JOIN StatsCache_TagMappingsByContentItem stats1 ON [stats1].[ContentItemID] = @ContentItemID AND [stats1].[AvgNumMappings] <> 0
		JOIN StatsCache_TagMappingsByContentItem stats2 ON [stats2].[ContentItemID] = ci.[ContentItemID] AND [stats2].[AvgNumMappings] <> 0
		WHERE ci.ContentItemID <> @ContentItemID 
		AND ci.PublishingStatus = 30
		GROUP BY ci.[ContentItemID],
			[stats1].[AvgNumMappings],
			[stats2].[AvgNumMappings],
			[stats1].[StDevNumMappings],
			[stats2].[StDevNumMappings],
			[stats1].[NumTags]
		HAVING (COUNT(t.[TagID]) - [stats1].[NumTags]*stats1.[AvgNumMappings]*[stats2].[AvgNumMappings]) / (stats1.[StDevNumMappings] * stats2.[StDevNumMappings] * ([stats1].[NumTags] - 1)) > @Threshold
		) correlationData
	ORDER BY Correlation DESC
END

GO
GRANT EXECUTE ON  [dbo].[GetMostSiteCorrelatedContentItems] TO [ssc_webapplication]
GO
