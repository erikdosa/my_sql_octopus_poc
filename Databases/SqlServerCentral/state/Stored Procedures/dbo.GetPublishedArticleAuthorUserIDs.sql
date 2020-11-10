SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetPublishedArticleAuthorUserIDs] 
AS
BEGIN
	-- Just returns the user IDs of all the users who have had articles published
	-- Is called by the mailing feature when sending emails to "all article authors"
	SELECT DISTINCT u.[UserID]
	FROM Users u
	JOIN [AuthorContentItem] aci ON aci.[UserID]=u.[UserID]
	JOIN ContentItems ci ON aci.[ContentItemID]=ci.[ContentItemID]
	JOIN [Articles] a ON ci.[ContentItemID] = a.[ContentItemID] /* Only articles */
	WHERE ci.[PublishingStatus] IN (30 /*Published*/, 25 /*Pending publish*/)
END



GO
