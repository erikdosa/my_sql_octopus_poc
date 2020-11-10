SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE FUNCTION [dbo].[GetTagMappingsWithMeanData] 
(	
	-- Add the parameters for the function here
	@tagID int
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT tmd.ContentItemID, tmd.NumMappings, AVG(tmd2.NumMappings*1000.0)/1000.0 MeanNumMappings
	FROM GetTagMappingsData(2) tmd
	JOIN (SELECT * FROM GetTagMappingsData(@tagID)) tmd2 ON 1=1
	GROUP BY tmd.ContentItemID, tmd.NumMappings
)



GO
