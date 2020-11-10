SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[GenerateEmailRecipientsRows] 
	@ForTestRecipients bit, -- 0 = live recipients, 1 = test recipients
	@ForSpecificEmailID int = NULL, -- Specify a particular email, or leave as null to indicate 'all due for sending'
	@ScheduleOffsetInHours INT = 0, -- Look for emails scheduled earlier than now + x hours, to allow for the long send time of newsletters. i.e. +4 would send email scheduled for 01.00 tomorrow at 21.00 tonight. 
	@RenderForums bit = 1 -- 0 = do not render, 1 = render
AS
BEGIN
	BEGIN TRAN
		-- Get a list of the emails due to be sent
		DECLARE @emails TABLE(EmailID int)
		IF @ForSpecificEmailID is null
		BEGIN
			INSERT INTO @emails
				SELECT EmailID FROM [Emails]
				WHERE 
				[ScheduleForDate] < DATEADD(hh, @ScheduleOffsetInHours, GETDATE()) 	-- Schedule date has been reached
				AND [ApprovedForSending] = 1	-- Approved
				AND [Status] = 1				-- Unsent
		END
		ELSE
		BEGIN
			INSERT INTO @emails SELECT @ForSpecificEmailID
		END

		IF @RenderForums = 1
		BEGIN
			-- Perform token replacement
			DECLARE @ForumPostsHTML Varchar(MAX), @ForumPostsPlainText Varchar(MAX)
			SELECT @ForumPostsHTML = Html, @ForumPostsPlainText = PlainText from dbo.RenderTodaysForumPosts()
			UPDATE [Emails]
			SET BodyHtml = Replace(CAST(BodyHtml as Varchar(max)), '{forumpostshtml}', @ForumPostsHTML),
				BodyPlainText = Replace(Cast(BodyPlainText as Varchar(max)), '{forumpoststext}', @ForumPostsPlainText)
			WHERE EmailID in (SELECT [EmailID] FROM @emails)
		END
		
		-- Clear out any recipients that have been recorded already
		-- (There wouldn't normally be any, but in testing there might)
		DELETE FROM [EmailRecipients] WHERE [EmailID] IN (SELECT [EmailID] FROM @emails)

		-- Add their "specific individual" recipients
		INSERT INTO [EmailRecipients] ([EmailID], [UserID])
			SELECT e.[EmailID], u.[UserID]
			FROM [EmailRecipientSources] ers
			JOIN @emails e ON e.[EmailID] = ers.[EmailID]
			JOIN [Users] u ON u.[UserID] = ers.[SpecificUserID]
			WHERE ers.[IsForTesting] = @ForTestRecipients

		-- Add their "arbitrary email address" recipients
		INSERT INTO [EmailRecipients] ([EmailID], [ArbitraryRecipientName], [ArbitraryRecipientEmailAddress])
			SELECT e.[EmailID], ers.[ArbitraryRecipientName], ers.[ArbitraryRecipientEmailAddress]
			FROM [EmailRecipientSources] ers
			JOIN @emails e ON e.[EmailID] = ers.[EmailID]
			WHERE ers.[IsForTesting] = @ForTestRecipients	
			AND (ers.[ArbitraryRecipientEmailAddress] IS NOT NULL)	

		-- Add their "role" recipients by querying the Single Signon database
		-- There's a huge performance gain in pulling all the MemberIDs into memory then 
		-- joining them to the User table rather than just joining directly 
		-- (possibly because the in-memory table is indexable, whereas the linked-server table isn't?)
		CREATE TABLE #MemberIDs (EmailID int, SingleSignonMemberID int)
		INSERT INTO #MemberIDs
			SELECT e.[EmailID], mr.MemberID
			FROM @emails e
			JOIN [EmailRecipientSources] ers ON ers.[EmailID] = e.[EmailID] AND ers.[IsForTesting]=@ForTestRecipients
			JOIN [SingleSignon].dbo.[MemberRoles] mr ON mr.RoleName = ers.RoleName
			JOIN [SingleSignon].dbo.[Members] m ON m.ID = mr.MemberID
			WHERE (NOT(m.ApprovalDate IS NULL)) AND (mr.DeletedDate IS NULL)
		INSERT INTO [EmailRecipients] ([EmailID], [UserID])
			SELECT DISTINCT m.EmailID, u.[UserID]
			FROM Users u
			JOIN #MemberIDs m ON u.[SingleSignonMemberID] = m.[SingleSignonMemberID]
		INSERT INTO NewsletterRecipientCounts 
			SELECT m.EmailID, @@ROWCOUNT
			FROM dbo.EmailRecipients 
			JOIN #MemberIDs m ON m.EmailID = dbo.EmailRecipients.EmailID
			GROUP BY m.EmailID
		DROP TABLE #MemberIDs

		-- Add their "named query" recipients
		DECLARE namedQueryCursor CURSOR FOR 
			SELECT e.[EmailID], ers.MailingGroupID 
			FROM [EmailRecipientSources] ers
			JOIN @emails e ON e.[EmailID] = ers.[EmailID] AND ers.[IsForTesting] = @ForTestRecipients
			JOIN sysobjects so ON so.TYPE='P' AND so.NAME = ers.[MailingGroupID] -- We require the MailingGroupID to exactly match the name of a stored procedure
		OPEN namedQueryCursor
			DECLARE @EmailID VARCHAR(100)
			DECLARE @MailingGroupID NVARCHAR(100)
			FETCH NEXT FROM namedQueryCursor INTO @EmailID, @MailingGroupID
			WHILE @@FETCH_STATUS <> -1
			BEGIN
				CREATE TABLE #SProcResults (UserID INT)
				INSERT INTO #SProcResults EXEC @MailingGroupID -- Note: executes arbitrary SQL here, but attack surface is minimised because you can only execute existing stored procs with no parameters
				
				INSERT INTO [EmailRecipients] ([EmailID], [UserID]) 
				SELECT @EmailID, UserID FROM #SProcResults
			
				DROP TABLE #SProcResults
			
				FETCH NEXT FROM namedQueryCursor INTO @EmailID, @MailingGroupID	
			END
		CLOSE namedQueryCursor
		DEALLOCATE namedQueryCursor

		-- Set mailing to 'Sent'
		UPDATE [Emails] SET [Status]=3 WHERE [EmailID] IN (SELECT [EmailID] FROM @emails)

	COMMIT TRAN
END





GO
GRANT EXECUTE ON  [dbo].[GenerateEmailRecipientsRows] TO [ssc_webapplication]
GO
