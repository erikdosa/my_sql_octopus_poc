SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Email_InsertNew] 
	@SenderName nvarchar(500),
	@SenderEmailAddress nvarchar(500),
	@RecipientName nvarchar(500),
	@RecipientEmailAddress nvarchar(500),
	@SubjectText nvarchar(500),
	@BodyHTML text,
	@BodyPlainText text,
	@ScheduleForDate datetime = NULL,
	@EmailTypeName varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- If no schedule date was specified, use 'now'
	IF @ScheduleForDate IS NULL
		SELECT @ScheduleForDate = GETDATE()

	-- Create a record for the email
	DECLARE @EmailID INT
	INSERT INTO Emails(RecordType, EmailTypeName, IsTest, UseClickTracking,
						SubjectText, BodyHTML, BodyPlainText,
						SenderName, SenderEmailAddress,
						[Status], ScheduleForDate, ApprovedForSending)
	VALUES ('Email', @EmailTypeName, 0, 0,
			@SubjectText, @BodyHTML, @BodyPlainText,
			@SenderName, @SenderEmailAddress,
			1, @ScheduleForDate, 1)
	SELECT @EmailID=Scope_Identity()

	-- Make an email recipient source for this arbitrary recipient
	INSERT INTO [EmailRecipients] 
		([EmailID], [ArbitraryRecipientName], [ArbitraryRecipientEmailAddress])
	VALUES (@EmailID, @RecipientName, @RecipientEmailAddress)

	-- Mark as ready for sending
	UPDATE [Emails] SET [Status]=3 WHERE [EmailID]=@EmailID
END



GO
GRANT EXECUTE ON  [dbo].[Email_InsertNew] TO [Emailer]
GO
GRANT EXECUTE ON  [dbo].[Email_InsertNew] TO [ForumsUser]
GO
GRANT EXECUTE ON  [dbo].[Email_InsertNew] TO [public]
GO
