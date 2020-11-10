CREATE TABLE [dbo].[ScheduleEntries]
(
[ScheduleEntryID] [int] NOT NULL IDENTITY(1, 1),
[ContentItemID] [int] NOT NULL,
[Site] [int] NOT NULL,
[StartDate] [datetime] NOT NULL,
[EndDate] [datetime] NULL,
[SortOrder] [float] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ScheduleEntries] ADD CONSTRAINT [PK_ScheduleEntries] PRIMARY KEY CLUSTERED  ([ScheduleEntryID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_ScheduleEntriesContentItemID] ON [dbo].[ScheduleEntries] ([ContentItemID]) INCLUDE ([SortOrder], [StartDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ssc_site] ON [dbo].[ScheduleEntries] ([Site], [StartDate], [EndDate]) INCLUDE ([ContentItemID], [ScheduleEntryID], [SortOrder]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ssc_startdate] ON [dbo].[ScheduleEntries] ([StartDate], [EndDate]) INCLUDE ([ContentItemID], [ScheduleEntryID], [Site], [SortOrder]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ScheduleEntries] ADD CONSTRAINT [FK_ScheduleEntries_ContentItems] FOREIGN KEY ([ContentItemID]) REFERENCES [dbo].[ContentItems] ([ContentItemID]) ON DELETE CASCADE
GO
GRANT DELETE ON  [dbo].[ScheduleEntries] TO [ssc_webapplication]
GO
GRANT INSERT ON  [dbo].[ScheduleEntries] TO [ssc_webapplication]
GO
GRANT SELECT ON  [dbo].[ScheduleEntries] TO [ssc_webapplication]
GO
GRANT UPDATE ON  [dbo].[ScheduleEntries] TO [ssc_webapplication]
GO
