SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[LogSearchTerms]
@UserID INT = NULL,
@Search NVARCHAR(1000)
AS
BEGIN

INSERT INTO UserSearches(UserID, Search)
	SELECT @UserID, @Search

-- return an int for NHibernate - there may be a way to not require a return value...
SELECT @@ERROR AS atatError

END



GO
GRANT EXECUTE ON  [dbo].[LogSearchTerms] TO [ssc_webapplication]
GO
