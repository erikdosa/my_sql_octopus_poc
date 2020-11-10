CREATE TABLE [dbo].[ClickTrackingClicks]
(
[ClickID] [int] NOT NULL IDENTITY(1, 1),
[UrlID] [int] NOT NULL,
[UserID] [int] NULL,
[Date] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ClickTrackingClicks] ADD CONSTRAINT [PK_ClickTrackingClicks] PRIMARY KEY CLUSTERED  ([ClickID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ClickTrackingClicks] ADD CONSTRAINT [FK_ClickTrackingClicks_ClickTrackingURLs] FOREIGN KEY ([UrlID]) REFERENCES [dbo].[ClickTrackingURLs] ([UrlID]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ClickTrackingClicks] ADD CONSTRAINT [FK_ClickTrackingClicks_Users] FOREIGN KEY ([UserID]) REFERENCES [dbo].[Users] ([UserID]) ON DELETE CASCADE
GO
GRANT INSERT ON  [dbo].[ClickTrackingClicks] TO [ssc_webapplication]
GO
