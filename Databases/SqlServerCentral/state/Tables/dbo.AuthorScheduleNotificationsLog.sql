CREATE TABLE [dbo].[AuthorScheduleNotificationsLog]
(
[NotificationID] [int] NOT NULL IDENTITY(1, 1),
[ScheduleEntryID] [int] NOT NULL,
[ContentItemID] [int] NOT NULL,
[ScheduleStartDate] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AuthorScheduleNotificationsLog] ADD CONSTRAINT [PK_AuthorScheduleNotificationsLog] PRIMARY KEY CLUSTERED  ([NotificationID]) ON [PRIMARY]
GO
