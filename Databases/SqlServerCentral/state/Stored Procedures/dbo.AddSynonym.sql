SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AddSynonym]
    @Word NVARCHAR(50) ,
    @Group INT
AS 
    BEGIN
        IF EXISTS ( SELECT  1
                    FROM    dbo.SearchAnalyzerConfig
                    WHERE   Word = @Word ) 
            UPDATE  dbo.SearchAnalyzerConfig
            SET     [Group] = @Group
            WHERE   Word = @Word
        ELSE 
            INSERT  INTO dbo.SearchAnalyzerConfig
                    ( Word, [Group] )
            VALUES  ( @Word, @Group )
		
		
        SELECT  @@ERROR AS 'atatError'
    END

GO
GRANT EXECUTE ON  [dbo].[AddSynonym] TO [ssc_webapplication]
GO
