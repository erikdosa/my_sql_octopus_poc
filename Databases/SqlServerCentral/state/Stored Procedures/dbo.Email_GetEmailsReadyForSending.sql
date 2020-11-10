SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Email_GetEmailsReadyForSending]
	--7/26/06 law
	--Rewritten to use config table, only process a single priority
AS 
    DECLARE @BatchSize INT
    DECLARE @ComputerName NVARCHAR(100) --updated from VARCHAR(50)
    DECLARE @Priority INT

    SET nocount ON

    SET @ComputerName = HOST_NAME()

	--see if machine is turned off or isnt configured
    IF NOT EXISTS ( SELECT  *
                    FROM    dbo.EmailerConfiguration
                    WHERE   ComputerName = @ComputerName
                            AND Active = 1 ) 
        RETURN

	--potentially we have known bad addresses in the table. Here we mark those as done/JUNK
	--so that we dont get false notifications of email stuck in queue
    UPDATE  er
    SET     SentDate = GETDATE() ,
            SendingComputerName = 'JUNK'
    FROM    dbo.Emails e
            JOIN EmailRecipients er ON er.EmailID = e.EmailID
            JOIN Users u ON u.UserID = er.UserID
            INNER JOIN dbo.BadEmailAddresses bad ON u.EmailAddress = bad.EmailAddress
    WHERE   er.SentDate IS NULL
            AND er.SendingComputerName IS NULL

	--get config info
    SELECT  @BatchSize = [BatchSize] ,
            @Priority = Priority
    FROM    dbo.EmailerConfiguration
    WHERE   ComputerName = @ComputerName

	--check to see if there are records we own that have not been sent. If so, probably means a previous run
	--failed and we should complete it before tagging more records. The view filters so that we only see
	--records that are ok to send right now. Note also Im not filtering by priority here, that avoids
	--orphaning records if the config changes
    IF NOT EXISTS ( SELECT  *
                    FROM    dbo.[vw_EmailQueuedReadyToSend]
                    WHERE   SendingComputerName = @ComputerName ) 
        BEGIN

			--this is from the table config
            SET ROWCOUNT @BatchSize

			--now we tag either priority 1 or 2 depending on config
            UPDATE  dbo.EmailRecipients
            SET     SendingComputerName = @ComputerName
            FROM    EmailRecipients er
                    INNER JOIN Emails e ON er.EmailID = e.EmailID
            WHERE   ( er.SentDate IS NULL )
                    AND er.SendingComputerName IS NULL
                    AND ( CASE WHEN e.EmailTypeName LIKE 'System:%' THEN 1
                               WHEN e.IsTest = 1 THEN 1
                               ELSE 2
                          END ) = @Priority
			
			--turn off the limit since we can now just select all records we own
            SET ROWCOUNT 0
        END

	--return all records assigned to us that have not been sent AND are not bad
	--addresses. We limit to 2000 to avoid performance issues. The Top N here
	--DOES NOT have to match the total of the two batches above, though it should be 
	--not be lower than the total. Subsequent batches would pick up any remaining
	--to be sent that are already tagged. Note that here again Im not filtering
	--by priority, if its tagged with the correct computername we need to process
	--it
    SELECT TOP 2000
            E.EmailRecipientID ,
            E.SenderEmailAddress ,
            E.SenderName ,
            E.RecipientEmailAddress ,
            E.RecipientDisplayName ,
            E.SubjectText ,
            E.BodyHTML ,
            E.BodyPlainText ,
            E.RecipientUserID ,
            E.EmailID ,
            E.ScheduleForDate ,
            CASE WHEN E.EmailTypeName = 'System:ForumEmail'
                      AND E.SenderEmailAddress != 'notifications@sqlservercentral.com'
                      AND E.SenderEmailAddress != 'subscriptions@sqlservercentral.com'
                      AND E.SenderEmailAddress != 'webmaster@sqlservercentral.com'
                 THEN 1
                 ELSE 0
            END AS IsFromUser
    FROM    dbo.[vw_EmailQueuedReadyToSend] E WITH ( NOLOCK )
    WHERE   E.SendingComputerName = @ComputerName
    ORDER BY E.ScheduleForDate ,
            EmailRecipientID


GO
GRANT EXECUTE ON  [dbo].[Email_GetEmailsReadyForSending] TO [Emailer]
GO
GRANT EXECUTE ON  [dbo].[Email_GetEmailsReadyForSending] TO [ssc_emailer]
GO
