CREATE ROLE [ssc_webapplication]
AUTHORIZATION [dbo]
GO
EXEC sp_addrolemember N'ssc_webapplication', N'ssc_web'
GO
