CREATE TABLE [dbo].[CommunityServerBlogs]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[BlogId] [int] NOT NULL,
[CommunityServerSectionId] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CommunityServerBlogs] ADD CONSTRAINT [PK__Communit__3214EC077755B73D] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CommunityServerBlogs] ADD CONSTRAINT [FKC8B93007582AE673] FOREIGN KEY ([BlogId]) REFERENCES [dbo].[Blogs] ([Id])
GO
GRANT INSERT ON  [dbo].[CommunityServerBlogs] TO [ssc_webapplication]
GO
GRANT SELECT ON  [dbo].[CommunityServerBlogs] TO [ssc_webapplication]
GO
GRANT UPDATE ON  [dbo].[CommunityServerBlogs] TO [ssc_webapplication]
GO
