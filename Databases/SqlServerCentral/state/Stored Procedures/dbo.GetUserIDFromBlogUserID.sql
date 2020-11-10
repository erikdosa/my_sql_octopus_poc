SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[GetUserIDFromBlogUserID]
	@BlogUserID int
AS
	SELECT SSCID
	FROM CommunityServer.dbo.cs_Users
	WHERE UserID = @BlogUserID

GO
GRANT EXECUTE ON  [dbo].[GetUserIDFromBlogUserID] TO [ssc_webapplication]
GO
