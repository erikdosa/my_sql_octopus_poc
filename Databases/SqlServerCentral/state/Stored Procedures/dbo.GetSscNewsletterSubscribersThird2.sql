SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[GetSscNewsletterSubscribersThird2]
AS BEGIN
	SELECT DISTINCT UserID
	FROM Users u
	JOIN [SingleSignon].dbo.[Members] m ON m.ID = u.SingleSignonMemberID
	JOIN [SingleSignon].dbo.[MemberRoles] mr ON mr.MemberID = m.ID
	WHERE RoleName = 'SSC.NewsletterSubscriber'
	AND (NOT(m.ApprovalDate IS NULL))
	AND (mr.DeletedDate IS NULL)
	AND UserID % 3 = 2
END

GO
