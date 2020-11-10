SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetPopularTags] 
	@ContentType VARCHAR(20),
	@MaxResults INT
AS
BEGIN

SET ROWCOUNT @MaxResults

IF @ContentType = 'Article'
BEGIN
	
	SELECT t.*
	FROM Tags t
	INNER JOIN dbo.TagMappings tm ON t.TagID = tm.TagID
	INNER JOIN dbo.Articles a ON tm.ContentItemID = a.ContentItemID
	GROUP BY t.TagText, t.TagID
	ORDER BY CASE t.TagText WHEN 'Video' THEN 1 ELSE 0 END DESC, COUNT(a.ContentItemID) DESC
	
END ELSE IF @ContentType = 'Script' 
BEGIN
	SELECT t.*
	FROM Tags t
	INNER JOIN dbo.TagMappings tm ON t.TagID = tm.TagID
	INNER JOIN dbo.Scripts s ON tm.ContentItemID = s.ContentItemID
	GROUP BY t.TagText, t.TagID
	ORDER BY COUNT(s.ContentItemID) DESC									
END	ELSE BEGIN
	SELECT t.*
	FROM Tags t
	INNER JOIN dbo.TagMappings tm ON t.TagID = tm.TagID
	INNER JOIN dbo.ContentItems c ON tm.ContentItemID = c.ContentItemID
	GROUP BY t.TagText, t.TagID
	ORDER BY COUNT(c.ContentItemID) DESC															
END
	
SET ROWCOUNT 0
END

GO
GRANT EXECUTE ON  [dbo].[GetPopularTags] TO [ssc_web]
GO
