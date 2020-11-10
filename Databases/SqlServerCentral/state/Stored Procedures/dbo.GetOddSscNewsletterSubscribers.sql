SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetOddSscNewsletterSubscribers]
AS BEGIN
	SELECT DISTINCT UserID
	FROM Users u
	JOIN [SingleSignon].dbo.[Members] m ON m.ID = u.SingleSignonMemberID
	JOIN [SingleSignon].dbo.[MemberRoles] mr ON mr.MemberID = m.ID
	WHERE RoleName = 'SSC.NewsletterSubscriber'
	AND (NOT(m.ApprovalDate IS NULL))
	AND (mr.DeletedDate IS NULL)
	AND UserID % 2 = 1
END


GO
