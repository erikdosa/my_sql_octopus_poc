SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROC [dbo].[GetBlogPostTags]
	@PostID INT
AS
	SELECT Name AS TagName
	FROM CommunityServer.dbo.cs_Posts_InCategories
	INNER JOIN CommunityServer.dbo.cs_Post_Categories
		ON CommunityServer.dbo.cs_Posts_InCategories.CategoryID = CommunityServer.dbo.cs_Post_Categories.CategoryID
		AND CommunityServer.dbo.cs_Posts_InCategories.SettingsID = CommunityServer.dbo.cs_Post_Categories.SettingsID
	WHERE PostID = @PostID

GO
GRANT EXECUTE ON  [dbo].[GetBlogPostTags] TO [ssc_webapplication]
GO
