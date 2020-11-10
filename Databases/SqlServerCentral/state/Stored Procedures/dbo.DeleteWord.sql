SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[DeleteWord] @Word NVARCHAR(50)
AS 
    BEGIN
        DELETE  dbo.SearchAnalyzerConfig
        WHERE   Word = @Word
		
        SELECT  @@ERROR AS 'atatError'
    END

GO
GRANT EXECUTE ON  [dbo].[DeleteWord] TO [ssc_webapplication]
GO
