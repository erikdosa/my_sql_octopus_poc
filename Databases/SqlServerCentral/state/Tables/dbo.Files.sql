CREATE TABLE [dbo].[Files]
(
[FileID] [int] NOT NULL,
[FileName] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FileExtension] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SizeInBytes] [bigint] NOT NULL,
[CreatedDate] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Files] ADD CONSTRAINT [PK_Files] PRIMARY KEY CLUSTERED  ([FileID]) ON [PRIMARY]
GO
GRANT DELETE ON  [dbo].[Files] TO [ssc_webapplication]
GO
GRANT INSERT ON  [dbo].[Files] TO [ssc_webapplication]
GO
GRANT SELECT ON  [dbo].[Files] TO [ssc_webapplication]
GO
GRANT UPDATE ON  [dbo].[Files] TO [ssc_webapplication]
GO
