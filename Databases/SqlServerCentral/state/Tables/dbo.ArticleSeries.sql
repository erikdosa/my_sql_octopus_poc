CREATE TABLE [dbo].[ArticleSeries]
(
[ContentItemID] [int] NOT NULL,
[BannerImageFileID] [int] NULL,
[AdvertImageID] [int] NULL,
[AdvertUrl] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsStairwaySeries] [bit] NOT NULL CONSTRAINT [DF__ArticleSe__IsSta__24285DB4] DEFAULT ((1))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ArticleSeries] ADD CONSTRAINT [PK__Stairway__B851BC8C3F115E1A] PRIMARY KEY CLUSTERED  ([ContentItemID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ArticleSeries] ADD CONSTRAINT [FK17BABB2D914BD28] FOREIGN KEY ([AdvertImageID]) REFERENCES [dbo].[Files] ([FileID])
GO
ALTER TABLE [dbo].[ArticleSeries] ADD CONSTRAINT [FK17BABB2DA18B6AD] FOREIGN KEY ([ContentItemID]) REFERENCES [dbo].[ContentItems] ([ContentItemID])
GO
ALTER TABLE [dbo].[ArticleSeries] ADD CONSTRAINT [FK17BABB2DABD78FE] FOREIGN KEY ([BannerImageFileID]) REFERENCES [dbo].[Files] ([FileID])
GO
GRANT INSERT ON  [dbo].[ArticleSeries] TO [ssc_webapplication]
GO
GRANT SELECT ON  [dbo].[ArticleSeries] TO [ssc_webapplication]
GO
GRANT UPDATE ON  [dbo].[ArticleSeries] TO [ssc_webapplication]
GO
