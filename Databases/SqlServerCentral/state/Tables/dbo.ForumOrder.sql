CREATE TABLE [dbo].[ForumOrder]
(
[ForumID] [int] NOT NULL,
[RowIndex] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ForumOrder] ADD CONSTRAINT [PK_ForumOrder] PRIMARY KEY CLUSTERED  ([ForumID]) ON [PRIMARY]
GO
