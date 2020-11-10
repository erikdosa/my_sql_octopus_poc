CREATE TABLE [dbo].[Scripts]
(
[ContentItemID] [int] NOT NULL,
[SqlCode] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Rgtool] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Scripts] ADD CONSTRAINT [PK_Scripts] PRIMARY KEY CLUSTERED  ([ContentItemID]) ON [PRIMARY]
GO
GRANT DELETE ON  [dbo].[Scripts] TO [ssc_webapplication]
GO
GRANT INSERT ON  [dbo].[Scripts] TO [ssc_webapplication]
GO
GRANT SELECT ON  [dbo].[Scripts] TO [ssc_webapplication]
GO
GRANT UPDATE ON  [dbo].[Scripts] TO [ssc_webapplication]
GO
