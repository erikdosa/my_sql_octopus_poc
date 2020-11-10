CREATE TABLE [dbo].[Users]
(
[UserID] [int] NOT NULL IDENTITY(1, 1),
[SingleSignonMemberID] [int] NOT NULL,
[EmailAddress] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DisplayName] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CompanyID] [int] NULL,
[Biography] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PostCode] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Country] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuthorFirstName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuthorLastName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuthorFullName] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuthorForumID] [int] NULL,
[IsRegularAuthor] [bit] NOT NULL CONSTRAINT [DF_Users_IsRegularAuthor] DEFAULT ((0)),
[LastLoginDate] [datetime] NOT NULL,
[PaymentDetails] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Users] ADD CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED  ([UserID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AuthorNames] ON [dbo].[Users] ([AuthorFullName]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_UsersDisplayName] ON [dbo].[Users] ([DisplayName]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_UsersEmailAddress] ON [dbo].[Users] ([EmailAddress]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_UsersSSOID] ON [dbo].[Users] ([SingleSignonMemberID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_UsersDisplayNameUserID] ON [dbo].[Users] ([UserID], [DisplayName]) ON [PRIMARY]
GO
GRANT SELECT ON  [dbo].[Users] TO [ForumsUser]
GO
GRANT DELETE ON  [dbo].[Users] TO [ssc_webapplication]
GO
GRANT INSERT ON  [dbo].[Users] TO [ssc_webapplication]
GO
GRANT SELECT ON  [dbo].[Users] TO [ssc_webapplication]
GO
GRANT UPDATE ON  [dbo].[Users] TO [ssc_webapplication]
GO
