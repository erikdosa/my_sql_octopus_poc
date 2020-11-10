CREATE TABLE [dbo].[Articles]
(
[ContentItemID] [int] NOT NULL,
[LoginRequired] [bit] NOT NULL CONSTRAINT [DF__Articles__LoginR__2334397B] DEFAULT ((1))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Articles] ADD CONSTRAINT [PK_Articles] PRIMARY KEY CLUSTERED  ([ContentItemID]) ON [PRIMARY]
GO
GRANT DELETE ON  [dbo].[Articles] TO [ssc_webapplication]
GO
GRANT INSERT ON  [dbo].[Articles] TO [ssc_webapplication]
GO
GRANT SELECT ON  [dbo].[Articles] TO [ssc_webapplication]
GO
GRANT UPDATE ON  [dbo].[Articles] TO [ssc_webapplication]
GO
