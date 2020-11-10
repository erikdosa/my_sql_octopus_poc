CREATE TABLE [dbo].[EmailRecipientSources]
(
[EmailRecipientSourceID] [int] NOT NULL IDENTITY(1, 1),
[EmailID] [int] NOT NULL,
[RoleName] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MailingGroupID] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SpecificUserID] [int] NULL,
[IsForTesting] [bit] NOT NULL,
[ArbitraryRecipientName] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ArbitraryRecipientEmailAddress] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EmailRecipientSources] ADD CONSTRAINT [PK_EmailRecipientsRoles] PRIMARY KEY CLUSTERED  ([EmailRecipientSourceID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_EmailRecipients_EmailID_IsForTesting] ON [dbo].[EmailRecipientSources] ([EmailID], [IsForTesting]) INCLUDE ([EmailRecipientSourceID], [MailingGroupID], [SpecificUserID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ssp_RoleName] ON [dbo].[EmailRecipientSources] ([RoleName]) INCLUDE ([EmailID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EmailRecipientSources] ADD CONSTRAINT [FK_EmailRecipientSources_Users] FOREIGN KEY ([SpecificUserID]) REFERENCES [dbo].[Users] ([UserID]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[EmailRecipientSources] ADD CONSTRAINT [FK_EmailRecipientsRoles_Emails] FOREIGN KEY ([EmailID]) REFERENCES [dbo].[Emails] ([EmailID]) ON DELETE CASCADE
GO
GRANT DELETE ON  [dbo].[EmailRecipientSources] TO [ssc_webapplication]
GO
GRANT INSERT ON  [dbo].[EmailRecipientSources] TO [ssc_webapplication]
GO
GRANT SELECT ON  [dbo].[EmailRecipientSources] TO [ssc_webapplication]
GO
GRANT UPDATE ON  [dbo].[EmailRecipientSources] TO [ssc_webapplication]
GO
