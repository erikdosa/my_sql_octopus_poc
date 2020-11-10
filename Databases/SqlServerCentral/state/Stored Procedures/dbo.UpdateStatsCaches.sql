SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UpdateStatsCaches] 
AS
BEGIN
	-- Update StatsCache_ContentItemMappingsByTag
	TRUNCATE TABLE StatsCache_ContentItemMappingsByTag
	INSERT INTO StatsCache_ContentItemMappingsByTag (TagID, AvgNumMappings, StDevNumMappings, NumContentItems)
	SELECT	TagID, 
			AVG(CAST(NumMappings as FLOAT)) AS AvgNumMappings, -- update from AVG(NumMappings*1.0)
			STDEV(NumMappings) AS StDevNumMappings, 
			COUNT(ContentItemID) AS NumContentItems
	FROM (	SELECT	t.TagID, 
					ci.ContentItemID, 
					COUNT(tm.TagID) AS NumMappings
			FROM dbo.ContentItems AS ci 
			CROSS JOIN dbo.Tags AS t 
			LEFT OUTER JOIN dbo.TagMappings AS tm ON tm.TagID = t.TagID AND tm.ContentItemID = ci.ContentItemID
			GROUP BY t.TagID, ci.ContentItemID
		 ) AS TagStats
	GROUP BY TagID

	-- Update StatsCache_TagMappingsByContentItem
	TRUNCATE TABLE StatsCache_TagMappingsByContentItem
	INSERT INTO StatsCache_TagMappingsByContentItem(ContentItemID, AvgNumMappings, StDevNumMappings, NumTags)
	SELECT	ContentItemID, 
			AVG(CAST(NumMappings as FLOAT)) AS AvgNumMappings, -- update from AVG(NumMappings*1.0)
			STDEV(NumMappings) AS StDevNumMappings, 
			COUNT(TagID) AS NumTags
	FROM	(	SELECT	ci.ContentItemID, 
						t.TagID, 
						COUNT(tm.TagID) AS NumMappings
				FROM dbo.ContentItems AS ci 
				CROSS JOIN dbo.Tags AS t 
				LEFT OUTER JOIN dbo.TagMappings AS tm ON tm.TagID = t.TagID AND tm.ContentItemID = ci.ContentItemID
				GROUP BY t.TagID, ci.ContentItemID
			) AS TagStats
	GROUP BY ContentItemID
END


GO
