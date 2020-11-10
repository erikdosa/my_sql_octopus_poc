SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[ListAnalysisEvents]
AS
	SELECT [AnalysisLogID],
	       [Time],
	       [Data],
	       [Count]
	FROM dbo.AnalysisLog
	WHERE [Data] NOT LIKE 'search_%' -- ignore the search events
	ORDER BY [Time]

GO
GRANT EXECUTE ON  [dbo].[ListAnalysisEvents] TO [ssc_webapplication]
GO
