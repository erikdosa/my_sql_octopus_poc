SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetPopularContent] 
@ContentType VARCHAR(30) = NULL,
@MaxResults  INT = 20
AS
BEGIN 

IF @ContentType = 'Article'
	SELECT TOP (@MaxResults) ci.ContentItemID
	FROM dbo.ContentItems ci
	JOIN Articles a ON a.ContentItemID = ci.ContentItemID
	ORDER BY ci.PopularityRank DESC
ELSE IF @ContentType = 'Script'
	SELECT TOP (@MaxResults) ci.ContentItemID
	FROM dbo.ContentItems ci
	JOIN Scripts s ON s.ContentItemID = ci.ContentItemID
	ORDER BY ci.PopularityRank DESC
ELSE 
	SELECT TOP (@MaxResults) ci.[ContentItemID] 
	FROM dbo.ContentItems ci
	ORDER BY ci.PopularityRank desc
END




GO
GRANT EXECUTE ON  [dbo].[GetPopularContent] TO [ssc_webapplication]
GO
