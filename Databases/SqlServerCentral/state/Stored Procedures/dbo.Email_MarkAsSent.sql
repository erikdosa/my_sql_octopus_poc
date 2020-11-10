SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Email_MarkAsSent]
	@EmailRecipientID int,
	@EmailAddress varchar(255) = null,		--only needed if invalidaddress=1
	@LogAsInvalidAddress bit = 0
AS
BEGIN
	set nocount on

	update dbo.EmailRecipients 
	set	SentDate = getdate()
	where EmailRecipientID = @EmailRecipientID

	if @LogAsInvalidAddress = 1
	Begin
		--check, but the table does allow duplicates, wont hurt anything
		if not exists (select * from dbo.BadEmailAddresses where EmailAddress = @EmailAddress)
			insert into dbo.BadEmailAddresses (EmailAddress, AddedDate)
			values (@EmailAddress, GetDate())
	End
END


GO
GRANT EXECUTE ON  [dbo].[Email_MarkAsSent] TO [Emailer]
GO
GRANT EXECUTE ON  [dbo].[Email_MarkAsSent] TO [ssc_emailer]
GO
