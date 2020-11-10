CREATE TABLE [dbo].[UserLogins]
(
[UserLoginRecordID] [int] NOT NULL IDENTITY(1, 1),
[UserID] [int] NOT NULL,
[Date] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[UserLogins] ADD CONSTRAINT [PK_UserLogins] PRIMARY KEY CLUSTERED  ([UserLoginRecordID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[UserLogins] ADD CONSTRAINT [FK_UserLogins_Users] FOREIGN KEY ([UserID]) REFERENCES [dbo].[Users] ([UserID]) ON DELETE CASCADE
GO
GRANT INSERT ON  [dbo].[UserLogins] TO [ssc_webapplication]
GO
GRANT SELECT ON  [dbo].[UserLogins] TO [ssc_webapplication]
GO
