CREATE TABLE [dbo].[NewsletterBounceLog]
(
[LogID] [int] NOT NULL IDENTITY(1, 1),
[Date] [datetime] NOT NULL CONSTRAINT [DF_NewsletterBounceLog_Date] DEFAULT (getdate()),
[EmailAddress] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BounceType] [int] NOT NULL,
[Processed] [bit] NULL CONSTRAINT [DF_NewsletterBounceLog_Processed] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[NewsletterBounceLog] ADD CONSTRAINT [PK_NewsletterBounceLog] PRIMARY KEY CLUSTERED  ([LogID]) ON [PRIMARY]
GO
