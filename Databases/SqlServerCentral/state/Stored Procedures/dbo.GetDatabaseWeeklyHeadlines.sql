SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetDatabaseWeeklyHeadlines] 
	@fromDate DateTime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	exec DatabaseWeekly.dbo.[sp_NewsletterGetIssue] @start=@fromDate
END



GO
GRANT EXECUTE ON  [dbo].[GetDatabaseWeeklyHeadlines] TO [ssc_webapplication]
GO
