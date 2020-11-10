CREATE TABLE [dbo].[StatsCache_ContentItemMappingsByTag]
(
[TagID] [int] NOT NULL,
[AvgNumMappings] [float] NOT NULL,
[StDevNumMappings] [float] NOT NULL,
[NumContentItems] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[StatsCache_ContentItemMappingsByTag] ADD CONSTRAINT [PK_TagMappingStatsCache] PRIMARY KEY CLUSTERED  ([TagID]) ON [PRIMARY]
GO
