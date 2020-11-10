CREATE TABLE [dbo].[SearchAnalyzerConfig]
(
[Word] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Group] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SearchAnalyzerConfig] ADD CONSTRAINT [PK_SearchAnalyzerConfig] PRIMARY KEY CLUSTERED  ([Word]) ON [PRIMARY]
GO
