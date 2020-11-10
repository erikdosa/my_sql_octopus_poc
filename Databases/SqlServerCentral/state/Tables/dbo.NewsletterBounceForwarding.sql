CREATE TABLE [dbo].[NewsletterBounceForwarding]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[BounceType] [int] NOT NULL,
[ForwardEmailAddress] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[NewsletterBounceForwarding] ADD CONSTRAINT [PK_NewsletterBounceForwarding] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
GRANT SELECT ON  [dbo].[NewsletterBounceForwarding] TO [ssc_emailer]
GO
