CREATE TABLE [dbo].[AnalysisLog]
(
[AnalysisLogID] [int] NOT NULL IDENTITY(1, 1),
[Time] [datetime] NOT NULL,
[Data] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_AnalysisImageLog_Data] DEFAULT (''),
[Count] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AnalysisLog] ADD CONSTRAINT [PK__AnalysisImageLog__1CBC4616] PRIMARY KEY CLUSTERED  ([AnalysisLogID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [_dta_index_AnalysisLog_8_562101043__K3_K2] ON [dbo].[AnalysisLog] ([Data], [Time]) ON [PRIMARY]
GO
