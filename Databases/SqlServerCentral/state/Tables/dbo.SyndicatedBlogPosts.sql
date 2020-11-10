CREATE TABLE [dbo].[SyndicatedBlogPosts]
(
[ContentItemID] [int] NOT NULL,
[SyndicatedId] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CommentUrl] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CommentFeedUrl] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SyndicatedBlogPosts] ADD CONSTRAINT [PK__Syndicat__B851BC8C09746778] PRIMARY KEY CLUSTERED  ([ContentItemID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SyndicatedBlogPosts] ADD CONSTRAINT [UQ__Syndicat__B0855D8C0C50D423] UNIQUE NONCLUSTERED  ([SyndicatedId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SyndicatedBlogPosts] ADD CONSTRAINT [FKA0D09C4FA18B6AD] FOREIGN KEY ([ContentItemID]) REFERENCES [dbo].[BlogPosts] ([ContentItemID])
GO
GRANT INSERT ON  [dbo].[SyndicatedBlogPosts] TO [ssc_webapplication]
GO
GRANT SELECT ON  [dbo].[SyndicatedBlogPosts] TO [ssc_webapplication]
GO
GRANT UPDATE ON  [dbo].[SyndicatedBlogPosts] TO [ssc_webapplication]
GO
