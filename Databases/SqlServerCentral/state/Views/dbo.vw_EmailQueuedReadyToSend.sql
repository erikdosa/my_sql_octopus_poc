SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vw_EmailQueuedReadyToSend]
AS
	SELECT e.*, 
		er.[EmailRecipientID], 
		er.UserID as RecipientUserID,
		er.[SendingComputerName], 
		(case when u.UserID is not null then u.EmailAddress else er.ArbitraryRecipientEmailAddress end) as RecipientEmailAddress,
		(case when u.UserID is not null then u.DisplayName else er.ArbitraryRecipientName end) as RecipientDisplayName,
		(CASE WHEN e.EmailTypeName LIKE 'System:%' THEN 1 WHEN e.IsTest = 1 THEN 1 ELSE 2 END) as Priority
	FROM Emails e 
	join EmailRecipients er on er.EmailID = e.EmailID
	left outer join Users u on u.UserID = er.UserID
	LEFT outer join dbo.BadEmailAddresses bad on (u.EmailAddress = bad.EmailAddress) or (er.ArbitraryRecipientEmailAddress = bad.EmailAddress)
	WHERE (er.SentDate is null) and (bad.[EmailAddress] IS NULL)


GO
EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[42] 4[31] 2[17] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "e"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 121
               Right = 220
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "er"
            Begin Extent = 
               Top = 126
               Left = 38
               Bottom = 304
               Right = 269
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "u"
            Begin Extent = 
               Top = 6
               Left = 258
               Bottom = 121
               Right = 448
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "bad"
            Begin Extent = 
               Top = 126
               Left = 307
               Bottom = 211
               Right = 459
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', 'SCHEMA', N'dbo', 'VIEW', N'vw_EmailQueuedReadyToSend', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=1
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'dbo', 'VIEW', N'vw_EmailQueuedReadyToSend', NULL, NULL
GO
