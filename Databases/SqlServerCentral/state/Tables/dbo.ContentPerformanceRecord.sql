CREATE TABLE [dbo].[ContentPerformanceRecord]
(
[ContentPerformanceRecordID] [int] NOT NULL IDENTITY(1, 1),
[ContentItemID] [int] NOT NULL,
[Day] [int] NOT NULL CONSTRAINT [DF_ContentPerformanceRecord_Day] DEFAULT ((0)),
[CountOfViews] [int] NOT NULL CONSTRAINT [DF_ContentPerformanceRecord_CountOfViews] DEFAULT ((0)),
[TotalRatings] [int] NOT NULL CONSTRAINT [DF_ContentPerformanceRecord_CountOfRatings] DEFAULT ((0)),
[AverageRating] [numeric] (18, 4) NOT NULL CONSTRAINT [DF_ContentPerformanceRecord_AverageRating] DEFAULT ((0)),
[ViewsLastNDays] [int] NOT NULL CONSTRAINT [DF_ContentPerformanceRecord_ViewsLastNDays] DEFAULT ((0)),
[TotalViews] [int] NOT NULL CONSTRAINT [DF_ContentPerformanceRecord_TotalViews] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ContentPerformanceRecord] ADD CONSTRAINT [PK_ContentPerformanceRecord] PRIMARY KEY CLUSTERED  ([ContentPerformanceRecordID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ssc_46] ON [dbo].[ContentPerformanceRecord] ([ContentItemID]) INCLUDE ([ContentPerformanceRecordID], [Day]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_ContentPerformanceRecord_Days_ContentItem] ON [dbo].[ContentPerformanceRecord] ([Day] DESC, [ContentItemID]) INCLUDE ([CountOfViews]) ON [PRIMARY]
GO
GRANT DELETE ON  [dbo].[ContentPerformanceRecord] TO [ssc_webapplication]
GO
GRANT INSERT ON  [dbo].[ContentPerformanceRecord] TO [ssc_webapplication]
GO
GRANT SELECT ON  [dbo].[ContentPerformanceRecord] TO [ssc_webapplication]
GO
GRANT UPDATE ON  [dbo].[ContentPerformanceRecord] TO [ssc_webapplication]
GO
