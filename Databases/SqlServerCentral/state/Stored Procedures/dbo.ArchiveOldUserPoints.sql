SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[ArchiveOldUserPoints] 
	@ArchiveThresholdDays int = 40
AS
BEGIN
	-- To prevent the UserPoints table getting too large, we only retain daily
	-- totals for the last 40 days. Older points are stored in a single (per-user-category-pair)
	-- archive record dated 2001-01-01. More specifically:
	--
	-- Definition: "Archivable" user points records are ones that are both
	--					- older than @ArchiveThresholdDays days
	--					- not dated '2001-01-01'
	--
	-- This proc takes all archivable user points records for each user, 
	--  * adds their total points value to their archive record (dated 2001-01-01) for that category
	--  * then deletes those archivable records
	--
	-- What's left are the recent entries, and the one-per-user-category archive record

	SET NOCOUNT ON;

	DECLARE @ArchiveMarkerDate DATETIME
	SET @ArchiveMarkerDate = '2001-01-01'

	-- Fix the date in case we pass midnight during processing...
	DECLARE @ArchiveBefore DATETIME
	SELECT @ArchiveBefore = DATEADD(DAY, -1*@ArchiveThresholdDays, GETDATE()) 

    BEGIN TRAN
		-- Make sure there's at least a blank (zero) archive record for everyone who's scored points recently in each category
		INSERT INTO UserPoints (UserID, Date, PointsScored, PointsCategory)
		SELECT up.UserID, @ArchiveMarkerDate, 0, up.PointsCategory
		FROM UserPoints up
		LEFT OUTER JOIN UserPoints up_archive ON [up_archive].date = @ArchiveMarkerDate AND [up_archive].UserID=up.UserID AND [up_archive].[PointsCategory]=up.[PointsCategory]
		WHERE up.Date < @ArchiveBefore
		AND up.Date <> @ArchiveMarkerDate
		AND [up_archive].PointsScored IS null
		GROUP BY up.UserID, [up_archive].PointsScored, up.PointsCategory

		-- Add the archivable points to the archive records
		UPDATE up_archive 
		SET up_archive.PointsScored = up_archive.PointsScored + aggregates.TotalPointsDueForArchive
		FROM UserPoints up_archive
		JOIN (SELECT up.UserID, 
					up.PointsCategory,
					SUM(up.PointsScored) AS TotalPointsDueForArchive					
			FROM UserPoints up
			WHERE up.Date < @ArchiveBefore
			AND up.Date <> @ArchiveMarkerDate
			GROUP BY up.UserID, up.PointsCategory) aggregates ON [aggregates].UserID = up_archive.UserID and [aggregates].PointsCategory = up_archive.PointsCategory
		WHERE up_archive.Date = @ArchiveMarkerDate

		-- Delete the archivable records
		DELETE FROM UserPoints 
			WHERE Date < @ArchiveBefore
			AND Date <> @ArchiveMarkerDate
	COMMIT TRAN
END



GO
