SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetUserBannedStatus] (@Username VARCHAR(200))
AS
BEGIN 
	DECLARE @UserIsBanned INT
	SET @UserIsBanned = (SELECT COUNT(username) 
						FROM SqlServerCentralForums.dbo.BannedUsers
						WHERE username = @Username)
	SELECT @UserIsBanned AS UserIsBanned
END

GO
GRANT EXECUTE ON  [dbo].[GetUserBannedStatus] TO [ssc_webapplication]
GO
