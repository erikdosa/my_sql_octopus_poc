SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetBlogList] 
AS
BEGIN
	SELECT s.SectionID, s.[Name]
	FROM CommunityServer.dbo.cs_Sections s
	WHERE s.ApplicationType = 1
	ORDER BY s.[Name]
END


GO
GRANT EXECUTE ON  [dbo].[GetBlogList] TO [ssc_webapplication]
GO
