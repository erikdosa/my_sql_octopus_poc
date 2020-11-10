SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[GetMostSiteCorrelatedTags] 
	@tagID int = 0,
	@MaxResults int = 5,
	@Threshold float = 0.1
AS
BEGIN
	SELECT TOP (@MaxResults) FullTagData.*, CorrelatedTags.Correlation
	FROM
	(	SELECT 	t.[TagID] as Y_id,
				(COUNT(ci.[ContentItemID]) - [stats1].NumContentItems*[stats1].[AvgNumMappings]*[stats2].[AvgNumMappings]) / ([stats1].[StDevNumMappings] * [stats2].[StDevNumMappings] * ([stats1].NumContentItems - 1)) AS Correlation
		FROM [ContentItems] ci
		CROSS JOIN [Tags] t
		JOIN [TagMappings] tm1 ON tm1.[TagID]=@tagID AND tm1.[ContentItemID] = ci.[ContentItemID]
		JOIN [TagMappings] tm2 ON tm2.[TagID]=t.[TagID] AND tm2.[ContentItemID] = ci.[ContentItemID]
		JOIN StatsCache_ContentItemMappingsByTag stats1 ON [stats1].[TagID]=@tagID AND [stats1].[AvgNumMappings] <> 0
		JOIN StatsCache_ContentItemMappingsByTag stats2 ON [stats2].[TagID]=t.[TagID] AND [stats2].[AvgNumMappings] <> 0
		WHERE t.TagID <> @tagID
		GROUP BY t.[TagID], [t].[TagText],
			[stats1].[AvgNumMappings],
			[stats2].[AvgNumMappings],
			[stats1].[StDevNumMappings],
			[stats2].[StDevNumMappings],
			[stats1].NumContentItems
		HAVING (COUNT(ci.[ContentItemID]) - [stats1].NumContentItems*[stats1].[AvgNumMappings]*[stats2].[AvgNumMappings]) / ([stats1].[StDevNumMappings] * [stats2].[StDevNumMappings] * ([stats1].NumContentItems - 1)) > @Threshold	
	) CorrelatedTags
	JOIN Tags FullTagData on FullTagData.TagID=CorrelatedTags.Y_id
	WHERE FullTagData.TagID <> @tagID
	ORDER BY CorrelatedTags.Correlation DESC
END

GO
GRANT EXECUTE ON  [dbo].[GetMostSiteCorrelatedTags] TO [ssc_webapplication]
GO
