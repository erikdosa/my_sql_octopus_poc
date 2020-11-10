SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Email_ArchiveOldEmails]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @BatchSize INT;
	DECLARE @ArchiveDate DATETIME;

	SET @BatchSize = 20000;
	SET @ArchiveDate = DATEADD(month, -6, GETDATE());

	BEGIN TRANSACTION;

    -- Check we don't have any orphaned results from before
	DELETE FROM dbo.Emails WHERE EmailID IN (SELECT EmailID FROM dbo.EmailsArchive)

	-- Move everything before the start of 2013 that isn't referenced any more, and which has been sent, into the archive
	INSERT INTO dbo.EmailsArchive SELECT TOP (@BatchSize) * from Emails 
	where EmailID not in (select EmailID from EmailRecipientSources) 
	and EmailID not in (select EmailID from EmailRecipients)
	and ScheduleForDate < @ArchiveDate
	and ApprovedForSending=1 -- Putting this on there allows it to use an index, which makes life faster
	and Status=3

	-- Now delete anything we've moved over
	DELETE FROM dbo.Emails WHERE EmailID IN (SELECT EmailID FROM dbo.EmailsArchive)

	COMMIT;
END

GO
