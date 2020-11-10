SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/* Procedure to calculate the appropriate longer term content performance to avoid
complicated queries on article views */
CREATE PROCEDURE [dbo].[RollContentPerformanceAggregates]
AS
BEGIN

DECLARE @Day INT
SET @Day = DATEDIFF(dd, '1 Jan 2007', GETDATE() )

INSERT INTO ContentPerformanceRecord (Day, ContentItemID, CountOfViews, TotalRatings, TotalViews, ViewsLastNDays, AverageRating )
	SELECT @Day, vw.ContentItemID, 0, vw.TotalRatings, vw.TotalViews, vw.ViewsLastNDays - ISNULL(oldcpr.CountOfViews, 0), vw.AverageRating
		FROM vw_CurrentContentPerformanceRecord vw 
			LEFT OUTER JOIN ContentPerformanceRecord oldcpr 
				ON Day = @Day - 31 AND oldcpr.ContentItemID = vw.ContentItemID       

DELETE FROM ContentPerformanceRecord WHERE Day < (@Day - 60)

END




GO
