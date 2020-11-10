CREATE TABLE [dbo].[NewsletterRecipientCounts]
(
[EmailID] [int] NOT NULL,
[RecipientCount] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[NewsletterRecipientCounts] ADD CONSTRAINT [PK__Newslett__7ED91AEF2DB1C7EE] PRIMARY KEY CLUSTERED  ([EmailID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[NewsletterRecipientCounts] ADD CONSTRAINT [fk_EmailID] FOREIGN KEY ([EmailID]) REFERENCES [dbo].[Emails] ([EmailID])
GO
