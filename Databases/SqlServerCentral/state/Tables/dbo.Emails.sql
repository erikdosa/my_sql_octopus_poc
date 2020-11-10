CREATE TABLE [dbo].[Emails]
(
[EmailID] [int] NOT NULL IDENTITY(1, 1),
[RecordType] [char] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EmailTypeName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IsTest] [bit] NULL,
[UseClickTracking] [bit] NOT NULL,
[SubjectText] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BodyHTML] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BodyPlainText] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SenderName] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SenderEmailAddress] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Status] [int] NULL,
[ScheduleForDate] [datetime] NULL,
[ApprovedForSending] [bit] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Emails] ADD CONSTRAINT [PK_Emails] PRIMARY KEY CLUSTERED  ([EmailID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ssp_996] ON [dbo].[Emails] ([RecordType], [EmailTypeName], [IsTest]) INCLUDE ([ApprovedForSending], [EmailID], [ScheduleForDate], [SenderEmailAddress], [SenderName], [Status], [SubjectText], [UseClickTracking]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ssc_316] ON [dbo].[Emails] ([RecordType], [IsTest], [EmailTypeName]) INCLUDE ([EmailID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ssp_48] ON [dbo].[Emails] ([ScheduleForDate]) INCLUDE ([ApprovedForSending], [EmailID], [EmailTypeName], [IsTest]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ssc_390] ON [dbo].[Emails] ([Status], [ApprovedForSending], [ScheduleForDate]) INCLUDE ([EmailID], [EmailTypeName]) ON [PRIMARY]
GO
GRANT DELETE ON  [dbo].[Emails] TO [ssc_webapplication]
GO
GRANT INSERT ON  [dbo].[Emails] TO [ssc_webapplication]
GO
GRANT SELECT ON  [dbo].[Emails] TO [ssc_webapplication]
GO
GRANT UPDATE ON  [dbo].[Emails] TO [ssc_webapplication]
GO
