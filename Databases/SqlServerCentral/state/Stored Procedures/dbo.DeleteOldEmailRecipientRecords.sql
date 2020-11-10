SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[DeleteOldEmailRecipientRecords]
AS
BEGIN
	-- Deletes EmailRecipient rows that are finished and over 30 days old
	-- Mass mailings deleted after 4 days
	DELETE FROM [EmailRecipients]
	WHERE [EmailRecipientID] IN 
	(
		SELECT [EmailRecipientID]
		FROM [EmailRecipients] er
		JOIN [Emails] e ON e.[EmailID]=er.[EmailID]
		WHERE e.[Status] = 3 		-- Email sent (so no more recipient records will be generated)
		AND er.[SentDate] IS NOT NULL 	-- This recipient record sent
		AND 
		(
			(er.[SentDate] < GETDATE() - 30)
			OR
			((er.[SentDate] < GETDATE() - 4) AND (e.[EmailTypeName] NOT LIKE 'System:%'))
		)
	)
END


GO
