SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetAllTagMappingData] 
(	)
RETURNS TABLE 
AS
RETURN 
(
	SELECT t.[TagID], ci.[ContentItemID], COUNT(tm.[TagMappingID]) AS NumMappings
	FROM [Tags] t
	CROSS JOIN [ContentItems] ci
	LEFT OUTER JOIN [TagMappings] tm ON  tm.[ContentItemID] = ci.[ContentItemID] AND tm.[TagID]=t.[TagID]
	GROUP BY t.[TagID], ci.[ContentItemID]
)

GO
