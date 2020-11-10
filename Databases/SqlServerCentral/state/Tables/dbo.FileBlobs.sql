CREATE TABLE [dbo].[FileBlobs]
(
[FileID] [int] NOT NULL IDENTITY(1, 1),
[Data] [image] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FileBlobs] ADD CONSTRAINT [PK_FileBlobs] PRIMARY KEY CLUSTERED  ([FileID]) ON [PRIMARY]
GO
GRANT DELETE ON  [dbo].[FileBlobs] TO [ssc_webapplication]
GO
GRANT INSERT ON  [dbo].[FileBlobs] TO [ssc_webapplication]
GO
GRANT SELECT ON  [dbo].[FileBlobs] TO [ssc_webapplication]
GO
GRANT UPDATE ON  [dbo].[FileBlobs] TO [ssc_webapplication]
GO
