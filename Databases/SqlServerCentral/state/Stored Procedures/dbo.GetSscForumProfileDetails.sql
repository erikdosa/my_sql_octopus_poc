SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetSscForumProfileDetails] ( @userId INT )
AS
BEGIN
	SET NOCOUNT OFF

	DECLARE @TotalPointsScored INT
	SET @TotalPointsScored = (SELECT AllPoints = SUM(PointsScored) FROM dbo.UserPoints WHERE UserID = @userId)

	SELECT Users.UserID, @TotalPointsScored AS TotalPoints, ifUsers.Twitter, ifUsers.Facebook, ifUsers.GooglePlus, ifUsers.LinkedIn, ifUsers.PublicEmailAddress 
	FROM dbo.Users 
		INNER JOIN SqlServerCentralForums.dbo.InstantASP_Users aspUsers ON aspUsers.SSCUserID = dbo.Users.UserID
		INNER JOIN SqlServerCentralForums.dbo.InstantForum_Users ifUsers ON ifUsers.UserID = aspUsers.UserID
		WHERE Users.UserID = @userId
END

GO
GRANT EXECUTE ON  [dbo].[GetSscForumProfileDetails] TO [ssc_webapplication]
GO
