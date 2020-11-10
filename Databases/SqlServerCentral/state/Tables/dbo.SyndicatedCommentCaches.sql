CREATE TABLE [dbo].[SyndicatedCommentCaches]
(
[Id] [int] NOT NULL,
[Count] [int] NOT NULL,
[LastUpdateUtc] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SyndicatedCommentCaches] ADD CONSTRAINT [PK__Syndicat__3214EC0711158940] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SyndicatedCommentCaches] ADD CONSTRAINT [FKBFEEE8BA111C3611] FOREIGN KEY ([Id]) REFERENCES [dbo].[SyndicatedBlogPosts] ([ContentItemID])
GO
GRANT INSERT ON  [dbo].[SyndicatedCommentCaches] TO [ssc_webapplication]
GO
GRANT SELECT ON  [dbo].[SyndicatedCommentCaches] TO [ssc_webapplication]
GO
GRANT UPDATE ON  [dbo].[SyndicatedCommentCaches] TO [ssc_webapplication]
GO
