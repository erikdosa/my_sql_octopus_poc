CREATE TABLE [dbo].[UserPoints]
(
[UserPointsRecordID] [int] NOT NULL IDENTITY(1, 1),
[UserID] [int] NOT NULL,
[Date] [smalldatetime] NOT NULL,
[PointsScored] [int] NOT NULL,
[PointsCategory] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[UserPoints] ADD CONSTRAINT [PK_UserPoints] PRIMARY KEY CLUSTERED  ([UserPointsRecordID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ssp_1212] ON [dbo].[UserPoints] ([Date]) INCLUDE ([UserPointsRecordID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_UserPoints_PointsCategoryUserID] ON [dbo].[UserPoints] ([PointsCategory], [UserID]) INCLUDE ([Date], [PointsScored]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ssc_UserID] ON [dbo].[UserPoints] ([UserID], [PointsCategory], [Date]) INCLUDE ([PointsScored]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[UserPoints] ADD CONSTRAINT [FK_UserPoints_Users] FOREIGN KEY ([UserID]) REFERENCES [dbo].[Users] ([UserID]) ON DELETE CASCADE
GO
GRANT INSERT ON  [dbo].[UserPoints] TO [ForumsUser]
GO
GRANT SELECT ON  [dbo].[UserPoints] TO [ForumsUser]
GO
GRANT INSERT ON  [dbo].[UserPoints] TO [ssc_webapplication]
GO
GRANT DELETE ON  [dbo].[UserPoints] TO [ssc_webapplication]
GO
GRANT SELECT ON  [dbo].[UserPoints] TO [ssc_webapplication]
GO
GRANT UPDATE ON  [dbo].[UserPoints] TO [ssc_webapplication]
GO
