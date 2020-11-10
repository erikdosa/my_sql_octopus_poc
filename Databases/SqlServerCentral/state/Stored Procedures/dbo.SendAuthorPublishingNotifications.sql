SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SendAuthorPublishingNotifications] 
AS
BEGIN
	--- Looks for schedule entries in the next n days which don't have a
	--- corresponding AuthorScheduleNotificationsLog entry (or differ from
	--- any log entry, e.g. if publish date has changed), and inserts rows
	--- "Emails" and "EmailRecipients" tables to inform the author.
	---
	--- A very crude email template system is provided below

	DECLARE @MaxDaysAdvanceNotice INT
	SET @MaxDaysAdvanceNotice=1 -- Determines how far in advance the authors are notified
	DECLARE @Newline CHAR(2)
	SET @Newline = char(10) + char(13)

	DECLARE @EmailTemplate VARCHAR(MAX)
	SET @EmailTemplate = 
		'*** PLEASE DO NOT REPLY - THIS IS AN AUTOMATICALLY-GENERATED EMAIL ***' + @Newline + @Newline
		+'Dear {author},' + @Newline + @Newline
		+'We are pleased to inform you that your submission "{title}" '
		+'is scheduled to be published on www.sqlservercentral.com on '
		+'{date}.' + @Newline + @Newline
		+'Please look out for a discussion of this item on our forums '
		+'at {forumurl} (on or after {date}).' + @Newline + @Newline
		+'Thanks for your submission! Best regards,'+ @Newline
		+'The SQL Server Central team' 
    
	DECLARE @BlogsEmailTemplate VARCHAR(MAX)
	SET @BlogsEmailTemplate = 
		'*** PLEASE DO NOT REPLY - THIS IS AN AUTOMATICALLY-GENERATED EMAIL ***' + @Newline + @Newline
		+'Dear {author},' + @Newline + @Newline
		+'We are pleased to inform you that your post "{title}" '
		+'is scheduled to appear on the SQLServerCentral.com homepage on {date}.' + @Newline + @Newline
		+'Best regards,'+ @Newline
		+'The SQL Server Central team'   

	BEGIN TRAN
		-- First get a list of the notifications that are due (and haven't already been sent)
		DECLARE @AuthorNotifications TABLE (RowID INT IDENTITY(1,1), ScheduleEntryID INT, Site INT, StartDate DATETIME, EndDate DATETIME, ContentItemID INT, Title VARCHAR(MAX), AuthorUserID INT, EmailAddress VARCHAR(MAX), DisplayName VARCHAR(MAX), AuthorFullName VARCHAR(MAX))
		INSERT INTO @AuthorNotifications
			SELECT se.[ScheduleEntryID], se.[Site], se.[StartDate], se.[EndDate], ci.[ContentItemID], ci.[Title], u.UserID, u.[EmailAddress], u.[DisplayName], u.[AuthorFullName]
			FROM [ScheduleEntries] se
			JOIN [ContentItems] ci ON ci.[ContentItemID]=se.[ContentItemID]
			JOIN [AuthorContentItem] aci ON aci.[ContentItemID] = ci.[ContentItemID]
			JOIN [Users] u ON u.[UserID] = aci.[UserID]
			LEFT OUTER JOIN AuthorScheduleNotificationsLog asnl ON asnl.ScheduleEntryID = se.ScheduleEntryID AND asnl.ContentItemID = se.ContentItemID AND asnl.ScheduleStartDate = se.StartDate
			WHERE se.[StartDate] BETWEEN GETDATE() AND GETDATE()+@MaxDaysAdvanceNotice
			AND se.[Site] IN (10, 30, 60, 80) -- Headlines, QotD, Featured scripts, Second look
			AND ci.[PublishingStatus] IN (25, 30) -- Really scheduled for publishing (i.e. published or pending-publish)
			AND asnl.NotificationID IS NULL -- Don't notify them more than once (unless the content item or start date has changed)

		-- Create Email/EmailRecipient records
		DECLARE eachNotification CURSOR LOCAL FOR (SELECT RowID FROM @AuthorNotifications)	
		OPEN eachNotification
		DECLARE @ThisRowID INT
		FETCH NEXT FROM eachNotification INTO @ThisRowID
		WHILE @@FETCH_STATUS = 0
		BEGIN
			-- Insert "Email" record
			INSERT INTO [Emails] ([RecordType], [EmailTypeName], [IsTest], [UseClickTracking], [SubjectText], [BodyHTML], [BodyPlainText], [SenderName], [SenderEmailAddress], [Status], [ScheduleForDate], [ApprovedForSending]) 
			SELECT 'Email', 'System:AuthorPublishingNotification', 0, 0, 
			-- Subject line
			CASE WHEN EXISTS(SELECT 1 FROM dbo.BlogPosts WHERE ContentItemID = an.ContentItemID)
				THEN '"' + an.Title + '" is scheduled for ' + RTRIM(DATENAME(weekday, an.StartDate) + ' ' + CONVERT(CHAR(32), an.StartDate, 107)) 
				ELSE '"' + an.Title + '" will be published on ' + RTRIM(DATENAME(weekday, an.StartDate) + ' ' + CONVERT(CHAR(32), an.StartDate, 107)) 
				END AS SubjectLine,	
			'', -- Empty HTML version
			-- Build the body text
			CASE WHEN EXISTS(SELECT 1 FROM dbo.BlogPosts WHERE ContentItemID = an.ContentItemID)
				THEN REPLACE(REPLACE(REPLACE(
						@BlogsEmailTemplate
						, '{author}', ISNULL(an.AuthorFullName, an.DisplayName))
						, '{title}', an.Title)
						, '{date}', RTRIM(DATENAME(weekday, an.StartDate) + ' ' + CONVERT(CHAR(32), an.StartDate, 107)))
				ELSE REPLACE(REPLACE(REPLACE(REPLACE(
						@EmailTemplate
						, '{author}', ISNULL(an.AuthorFullName, an.DisplayName))
						, '{title}', an.Title)
						, '{date}', RTRIM(DATENAME(weekday, an.StartDate) + ' ' + CONVERT(CHAR(32), an.StartDate, 107))) 
						, '{forumurl}', 'http://www.sqlservercentral.com/FindForumThread/' + CAST(an.ContentItemID AS VARCHAR(20)))
				END AS BodyText,
			'SQL Server Central', 'notifications@sqlservercentral.com', 3, GETDATE(), 1
			FROM @AuthorNotifications an WHERE an.RowID = @ThisRowID
			
			-- Insert "EmailRecipient" record
			INSERT INTO [EmailRecipients] ([EmailID], [UserID]) 
			SELECT SCOPE_IDENTITY(), an.AuthorUserID
			FROM @AuthorNotifications an WHERE an.RowID = @ThisRowID

			FETCH NEXT FROM eachNotification INTO @ThisRowID
		END
		CLOSE eachNotification
		DEALLOCATE eachNotification

		-- Record the fact that notifications were sent
		INSERT INTO AuthorScheduleNotificationsLog (ScheduleEntryID, ContentItemID, ScheduleStartDate)
		SELECT ScheduleEntryID, ContentItemID, StartDate FROM @AuthorNotifications

	COMMIT TRAN
END


GO
