CREATE TABLE [dbo].[MailboxMonitorConfiguration]
(
[ID] [int] NOT NULL,
[MailboxAddress] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MailBoxPassword] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MailServer] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AccountType] [tinyint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MailboxMonitorConfiguration] ADD CONSTRAINT [PK_UnsubscribeConfiguration] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
