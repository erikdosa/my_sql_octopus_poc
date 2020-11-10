CREATE TABLE [dbo].[AuthorContentItem]
(
[ContentItemID] [int] NOT NULL,
[UserID] [int] NOT NULL,
[ordering] [tinyint] NOT NULL CONSTRAINT [DF_AuthorContentItem_ordering] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AuthorContentItem] ADD CONSTRAINT [PK_AuthorContentItem] PRIMARY KEY CLUSTERED  ([ContentItemID], [UserID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AuthorContentItem_UserID] ON [dbo].[AuthorContentItem] ([UserID]) ON [PRIMARY]
GO
GRANT DELETE ON  [dbo].[AuthorContentItem] TO [ssc_webapplication]
GO
GRANT INSERT ON  [dbo].[AuthorContentItem] TO [ssc_webapplication]
GO
GRANT SELECT ON  [dbo].[AuthorContentItem] TO [ssc_webapplication]
GO
GRANT UPDATE ON  [dbo].[AuthorContentItem] TO [ssc_webapplication]
GO
