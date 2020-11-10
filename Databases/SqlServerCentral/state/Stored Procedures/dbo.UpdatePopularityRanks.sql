SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UpdatePopularityRanks]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	UPDATE dbo.ContentItems
	SET PopularityRank = cpr.PopularityRank
	FROM dbo.vw_CurrentContentPerformanceRecord cpr
	WHERE ContentItems.ContentItemID = cpr.ContentItemID
END

GO
