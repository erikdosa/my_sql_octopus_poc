CREATE TABLE [dbo].[FileContentItems]
(
[FileID] [int] NOT NULL,
[ContentItemID] [int] NOT NULL
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [FileID] ON [dbo].[FileContentItems] ([FileID]) ON [PRIMARY]
GO
GRANT DELETE ON  [dbo].[FileContentItems] TO [ssc_webapplication]
GO
GRANT INSERT ON  [dbo].[FileContentItems] TO [ssc_webapplication]
GO
GRANT SELECT ON  [dbo].[FileContentItems] TO [ssc_webapplication]
GO
GRANT UPDATE ON  [dbo].[FileContentItems] TO [ssc_webapplication]
GO
