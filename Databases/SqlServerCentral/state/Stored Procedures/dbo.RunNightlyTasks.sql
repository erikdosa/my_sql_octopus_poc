SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[RunNightlyTasks] 
AS
BEGIN
	-- This should be run daily, just after midnight

	exec RollContentPerformanceAggregates -- Stores daily data on content views and ratings
	exec UpdateStatsCaches -- Caches stats used for the "related content" queries
	exec UpdatePublishingStatuses -- Moves items from "PendingPublish" to "Published" when ready
--	exec GenerateEmailRecipientsRows @ForTestRecipients=0 -- Dispatches the day's mailings
	exec ArchiveOldUserPoints @ArchiveThresholdDays = 30 -- Archives the points records to keep the data set managable
	exec DeleteOldEmailRecipientRecords -- Tidies the EmailRecipients table 
END


GO
