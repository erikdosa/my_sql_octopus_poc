CREATE TABLE [dbo].[Tags]
(
[TagID] [int] NOT NULL IDENTITY(1, 1),
[TagText] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Tags] ADD CONSTRAINT [PK_Tags] PRIMARY KEY CLUSTERED  ([TagID]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Tags_TagText] ON [dbo].[Tags] ([TagText]) ON [PRIMARY]
GO
GRANT DELETE ON  [dbo].[Tags] TO [ssc_webapplication]
GO
GRANT INSERT ON  [dbo].[Tags] TO [ssc_webapplication]
GO
GRANT SELECT ON  [dbo].[Tags] TO [ssc_webapplication]
GO
GRANT UPDATE ON  [dbo].[Tags] TO [ssc_webapplication]
GO
