SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetDynamicPagesForSitemap]
AS
BEGIN
	
SELECT c.ContentItemID, c.ShortTitle, t.TagText AS PrimaryTag, 
	CASE 
		WHEN art.ContentItemID IS NOT NULL THEN 'article'
		WHEN scr.ContentItemID IS NOT NULL THEN 'script'
		WHEN q.ContentItemID IS NOT NULL THEN 'question'
	END AS ContentType,
	c.LastModifiedDate
FROM dbo.ContentItems c
LEFT OUTER JOIN dbo.Tags t ON c.PrimaryTagID = t.TagID
LEFT OUTER JOIN dbo.Articles art ON c.ContentItemID = art.ContentItemID
LEFT OUTER JOIN dbo.Scripts scr ON c.ContentItemID = scr.ContentItemID
LEFT OUTER JOIN dbo.Questions q ON c.ContentItemID = q.ContentItemID
WHERE art.ContentItemID IS NOT NULL OR scr.ContentItemID IS NOT NULL OR q.ContentItemID IS NOT NULL

END


GO
GRANT EXECUTE ON  [dbo].[GetDynamicPagesForSitemap] TO [ssc_webapplication]
GO
