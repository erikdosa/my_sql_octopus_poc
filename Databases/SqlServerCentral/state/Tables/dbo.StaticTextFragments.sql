CREATE TABLE [dbo].[StaticTextFragments]
(
[StaticTextFragmentID] [int] NOT NULL IDENTITY(1, 1),
[KeyText] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StaticText] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContainsTokens] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[StaticTextFragments] ADD CONSTRAINT [PK_StaticTextFragments] PRIMARY KEY CLUSTERED  ([StaticTextFragmentID]) ON [PRIMARY]
GO
GRANT INSERT ON  [dbo].[StaticTextFragments] TO [ssc_webapplication]
GO
GRANT SELECT ON  [dbo].[StaticTextFragments] TO [ssc_webapplication]
GO
GRANT UPDATE ON  [dbo].[StaticTextFragments] TO [ssc_webapplication]
GO
