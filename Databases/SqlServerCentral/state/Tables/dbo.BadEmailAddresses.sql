CREATE TABLE [dbo].[BadEmailAddresses]
(
[EmailAddress] [nvarchar] (450) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AddedDate] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[BadEmailAddresses] ADD CONSTRAINT [PK_BadEmailAddresses] PRIMARY KEY CLUSTERED  ([EmailAddress]) ON [PRIMARY]
GO
