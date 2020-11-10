SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[User_BanUser] (@Username VARCHAR(200))
AS
BEGIN
	IF NOT EXISTS (SELECT * 
					FROM SqlServerCentralForums.dbo.BannedUsers
					WHERE username = @Username)
	BEGIN
		INSERT INTO SqlServerCentralForums.dbo.BannedUsers
				( username )
		VALUES  ( @Username )
        SELECT @Username AS username
	END
END

GO
GRANT EXECUTE ON  [dbo].[User_BanUser] TO [ssc_webapplication]
GO
