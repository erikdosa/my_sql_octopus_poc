SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*
- The "popularity" of the content item is computed in the "PopularityRank" column returned below
-
- Note that popularity is designed to decay exponentially over time
- In the formula, the division by 6 sets the half-life of popularity to 6 months
- ... tweak this value if desired 
-
- The average rating is normalised to the -2..+2 range by the -3 term. This is because
- votes in the lower half of the range should be understood as votes *against* the
- item, not weak votes in favour of the item.
-
- The DirtyTotalView/DirtyTotalRatings columns are to support NHibernate not being able
- to map two properties to the same column.
*/
CREATE VIEW [dbo].[vw_CurrentContentPerformanceRecord]
AS
SELECT  cpr.ContentPerformanceRecordID,
        cpr.ContentItemID,
        cpr.CountOfViews,
        cpr.ViewsLastNDays,
        cpr.TotalRatings,
        cpr.AverageRating,
        cpr.TotalViews,
		cpr.TotalViews * ((CASE WHEN ISNULL(cpr.[AverageRating],0)=0 THEN 3 ELSE cpr.[AverageRating] END) - 3) * EXP(LOG(0.5) * DATEDIFF(MONTH, ci.[CreatedDate], GETDATE()) / 6) AS PopularityRank,
		cpr.CountOfViews AS DirtyCountOfViews,
		cpr.TotalRatings AS DirtyTotalRatings
FROM    dbo.ContentPerformanceRecord AS cpr
JOIN [ContentItems] ci ON ci.[ContentItemID] = cpr.[ContentItemID]
WHERE   (Day = (SELECT  MAX(Day)
                FROM    dbo.ContentPerformanceRecord AS cpr2
                WHERE   (cpr2.ContentItemID = cpr.ContentItemID)))





GO
GRANT SELECT ON  [dbo].[vw_CurrentContentPerformanceRecord] TO [ssc_webapplication]
GO
EXEC sp_addextendedproperty N'MS_DiagramPane1', N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
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
         Begin Table = "cpr1"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 220
               Right = 316
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
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
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
', 'SCHEMA', N'dbo', 'VIEW', N'vw_CurrentContentPerformanceRecord', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=1
EXEC sp_addextendedproperty N'MS_DiagramPaneCount', @xp, 'SCHEMA', N'dbo', 'VIEW', N'vw_CurrentContentPerformanceRecord', NULL, NULL
GO
