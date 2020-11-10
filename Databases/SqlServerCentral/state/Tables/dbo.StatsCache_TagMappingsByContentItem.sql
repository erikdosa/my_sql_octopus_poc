CREATE TABLE [dbo].[StatsCache_TagMappingsByContentItem]
(
[ContentItemID] [int] NOT NULL,
[AvgNumMappings] [float] NOT NULL,
[StDevNumMappings] [float] NOT NULL,
[NumTags] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[StatsCache_TagMappingsByContentItem] ADD CONSTRAINT [PK_ContentTagMappingStatsCache] PRIMARY KEY CLUSTERED  ([ContentItemID]) ON [PRIMARY]
GO
