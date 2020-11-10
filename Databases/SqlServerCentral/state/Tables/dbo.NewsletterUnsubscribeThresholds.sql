CREATE TABLE [dbo].[NewsletterUnsubscribeThresholds]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[EmailTypeName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BounceType] [int] NOT NULL,
[DaysWindow] [int] NOT NULL,
[Threshold] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[NewsletterUnsubscribeThresholds] ADD CONSTRAINT [PK_NewsletterUnsubscribeThresholds] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
