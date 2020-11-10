SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[User_AllowUser] (@Username VARCHAR(200))
AS
BEGIN
	IF EXISTS (SELECT * 
					FROM SqlServerCentralForums.dbo.BannedUsers
					WHERE username = @Username)
	BEGIN
		DELETE FROM SqlServerCentralForums.dbo.BannedUsers
		WHERE username = @Username
        SELECT @Username AS username
	END
END

GO
GRANT EXECUTE ON  [dbo].[User_AllowUser] TO [ssc_webapplication]
GO
