CREATE TABLE [dbo].[ForumTopics]
(
[ContentItemID] [int] NOT NULL,
[ForumTopicId] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ForumTopics] ADD CONSTRAINT [PK__ForumTop__B851BC8C540C7B00] PRIMARY KEY CLUSTERED  ([ContentItemID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ForumTopics] ADD CONSTRAINT [UQ__ForumTop__1362261F56E8E7AB] UNIQUE NONCLUSTERED  ([ForumTopicId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ForumTopics] ADD CONSTRAINT [FK2D3B102CA18B6AD] FOREIGN KEY ([ContentItemID]) REFERENCES [dbo].[ContentItems] ([ContentItemID])
GO
GRANT DELETE ON  [dbo].[ForumTopics] TO [ssc_webapplication]
GO
GRANT INSERT ON  [dbo].[ForumTopics] TO [ssc_webapplication]
GO
GRANT SELECT ON  [dbo].[ForumTopics] TO [ssc_webapplication]
GO
GRANT UPDATE ON  [dbo].[ForumTopics] TO [ssc_webapplication]
GO
