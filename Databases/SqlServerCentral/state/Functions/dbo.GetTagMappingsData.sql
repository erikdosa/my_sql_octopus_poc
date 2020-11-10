SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetTagMappingsData] 
(	
	-- Add the parameters for the function here
	@tagID int
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	SELECT ci.[ContentItemID], 
	COUNT(tm.[TagID]) AS NumMappings
	FROM [ContentItems] ci
	LEFT OUTER JOIN [TagMappings] tm ON ci.[ContentItemID] = tm.[ContentItemID] AND tm.[TagID]=@tagID
	GROUP BY ci.[ContentItemID]
)

GO
