SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vw_Articles]
AS
SELECT     dbo.ContentItems.ContentItemID, dbo.ContentItems.PrimaryTagID, dbo.Tags.TagText, dbo.ContentItems.Title, dbo.ContentItems.ShortTitle, 
                      dbo.ContentItems.Description, dbo.ContentItems.Text, dbo.ContentItems.ExternalURL, dbo.ContentItems.PublishingStatus, dbo.ContentItems.SourceID, 
                      ContentItems_1.Title AS SourceTitle, ContentItems_1.ShortTitle AS SourceShortTitle, ContentItems_1.ExternalURL AS SourceURL, 
                      dbo.ContentItems.ForumThreadID, dbo.ContentItems.UpdatesContentItemID, dbo.ContentItems.CreatedDate, dbo.ContentItems.LastModifiedDate
FROM         dbo.ContentItems AS ContentItems_1 INNER JOIN
                      dbo.Sources ON ContentItems_1.ContentItemID = dbo.Sources.ContentItemID RIGHT OUTER JOIN
                      dbo.ContentItems INNER JOIN
                      dbo.Articles ON dbo.ContentItems.ContentItemID = dbo.Articles.ContentItemID ON 
                      dbo.Sources.ContentItemID = dbo.ContentItems.SourceID LEFT OUTER JOIN
                      dbo.Tags ON dbo.ContentItems.PrimaryTagID = dbo.Tags.TagID



GO
EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[36] 2[7] 3) )"
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
         Begin Table = "ContentItems_1"
            Begin Extent = 
               Top = 149
               Left = 632
               Bottom = 264
               Right = 825
            End
            DisplayFlags = 280
            TopColumn = 4
         End
         Begin Table = "Sources"
            Begin Extent = 
               Top = 18
               Left = 688
               Bottom = 88
               Right = 841
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ContentItems"
            Begin Extent = 
               Top = 42
               Left = 15
               Bottom = 302
               Right = 243
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Articles"
            Begin Extent = 
               Top = 5
               Left = 285
               Bottom = 75
               Right = 438
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Tags"
            Begin Extent = 
               Top = 175
               Left = 431
               Bottom = 275
               Right = 583
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
      Begin ColumnWidths = 20
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      ', 'SCHEMA', N'dbo', 'VIEW', N'vw_Articles', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_DiagramPane2', N'   Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 2355
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
', 'SCHEMA', N'dbo', 'VIEW', N'vw_Articles', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=2
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'dbo', 'VIEW', N'vw_Articles', NULL, NULL
GO
