SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[UpdatePublishingStatuses] 
	@OffsetHours FLOAT = 0 -- Marks as 'published' this number of hours early
AS
BEGIN
	-- Moves content items from "Pending published" to "Published" when
	-- a schedule entry for that item is reached 
	
	-- Run this stored proc frequently (at least daily, just after midnight)

	UPDATE ci
	SET PublishingStatus = 30			-- Set to "Published"
	FROM [ContentItems] ci
	JOIN [ScheduleEntries] se ON se.[ContentItemID] = ci.[ContentItemID]
	WHERE ci.PublishingStatus = 25		-- Currently in "Pending publish"
	AND se.[StartDate] <= DATEADD(minute, @OffsetHours*60, GETDATE())	-- Has a schedule entry today, or in the past
END

GO
