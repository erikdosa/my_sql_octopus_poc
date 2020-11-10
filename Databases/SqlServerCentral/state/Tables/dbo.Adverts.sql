CREATE TABLE [dbo].[Adverts]
(
[ContentItemID] [int] NOT NULL,
[PlainTextRepresentation] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Adverts] ADD CONSTRAINT [PK_Adverts] PRIMARY KEY CLUSTERED  ([ContentItemID]) ON [PRIMARY]
GO
GRANT INSERT ON  [dbo].[Adverts] TO [ssc_webapplication]
GO
GRANT SELECT ON  [dbo].[Adverts] TO [ssc_webapplication]
GO
GRANT UPDATE ON  [dbo].[Adverts] TO [ssc_webapplication]
GO
