CREATE TABLE [dbo].[StairwaySeriesArticles]
(
[StairwaySeriesId] [int] NOT NULL,
[ArticleId] [int] NOT NULL,
[ArticleIndex] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[StairwaySeriesArticles] ADD CONSTRAINT [PK__Stairway__06BD53F242E1EEFE] PRIMARY KEY CLUSTERED  ([StairwaySeriesId], [ArticleIndex]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[StairwaySeriesArticles] ADD CONSTRAINT [FK25F65AF493F88999] FOREIGN KEY ([ArticleId]) REFERENCES [dbo].[Articles] ([ContentItemID])
GO
ALTER TABLE [dbo].[StairwaySeriesArticles] ADD CONSTRAINT [FK25F65AF4D962E20A] FOREIGN KEY ([StairwaySeriesId]) REFERENCES [dbo].[ArticleSeries] ([ContentItemID])
GO
GRANT DELETE ON  [dbo].[StairwaySeriesArticles] TO [ssc_webapplication]
GO
GRANT INSERT ON  [dbo].[StairwaySeriesArticles] TO [ssc_webapplication]
GO
GRANT SELECT ON  [dbo].[StairwaySeriesArticles] TO [ssc_webapplication]
GO
GRANT UPDATE ON  [dbo].[StairwaySeriesArticles] TO [ssc_webapplication]
GO
