CREATE TABLE [dbo].[BriefcaseEntries]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[UserID] [int] NOT NULL,
[ContentItemID] [int] NOT NULL,
[Notes] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime] NOT NULL,
[LastModifiedDate] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[BriefcaseEntries] ADD CONSTRAINT [PK__Briefcas__3214EC074B7734FF] PRIMARY KEY CLUSTERED  ([Id]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_UserID] ON [dbo].[BriefcaseEntries] ([UserID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[BriefcaseEntries] ADD CONSTRAINT [FKC43F472254A2F41C] FOREIGN KEY ([UserID]) REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[BriefcaseEntries] ADD CONSTRAINT [FKC43F4722A18B6AD] FOREIGN KEY ([ContentItemID]) REFERENCES [dbo].[ContentItems] ([ContentItemID])
GO
GRANT DELETE ON  [dbo].[BriefcaseEntries] TO [ssc_webapplication]
GO
GRANT INSERT ON  [dbo].[BriefcaseEntries] TO [ssc_webapplication]
GO
GRANT SELECT ON  [dbo].[BriefcaseEntries] TO [ssc_webapplication]
GO
GRANT UPDATE ON  [dbo].[BriefcaseEntries] TO [ssc_webapplication]
GO
