CREATE TABLE [dbo].[ClickTrackingURLs]
(
[UrlID] [int] NOT NULL IDENTITY(1, 1),
[EmailID] [int] NOT NULL,
[Url] [varchar] (800) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ClickTrackingURLs] ADD CONSTRAINT [PK_ClickTrackingURLs] PRIMARY KEY CLUSTERED  ([UrlID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ssc_emailid] ON [dbo].[ClickTrackingURLs] ([EmailID]) INCLUDE ([Url]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ClickTrackingURLs] ADD CONSTRAINT [FK_ClickTrackingURLs_Emails] FOREIGN KEY ([EmailID]) REFERENCES [dbo].[Emails] ([EmailID]) ON DELETE CASCADE
GO
GRANT DELETE ON  [dbo].[ClickTrackingURLs] TO [ssc_webapplication]
GO
GRANT INSERT ON  [dbo].[ClickTrackingURLs] TO [ssc_webapplication]
GO
GRANT SELECT ON  [dbo].[ClickTrackingURLs] TO [ssc_webapplication]
GO
GRANT UPDATE ON  [dbo].[ClickTrackingURLs] TO [ssc_webapplication]
GO
