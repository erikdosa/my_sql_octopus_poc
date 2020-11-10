CREATE TABLE [dbo].[Sources]
(
[ContentItemID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Sources] ADD CONSTRAINT [PK_Sources] PRIMARY KEY CLUSTERED  ([ContentItemID]) ON [PRIMARY]
GO
GRANT DELETE ON  [dbo].[Sources] TO [ssc_webapplication]
GO
GRANT INSERT ON  [dbo].[Sources] TO [ssc_webapplication]
GO
GRANT SELECT ON  [dbo].[Sources] TO [ssc_webapplication]
GO
GRANT UPDATE ON  [dbo].[Sources] TO [ssc_webapplication]
GO
