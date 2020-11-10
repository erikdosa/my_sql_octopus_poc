SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[NewSynonymGroup]
    @Word NVARCHAR(50)
AS 
    BEGIN
		DECLARE @Group INT
		
		SELECT @Group = MAX([Group]) + 1
		FROM dbo.SearchAnalyzerConfig
		
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
        
        SELECT @Group AS 'Group'
    END

GO
GRANT EXECUTE ON  [dbo].[NewSynonymGroup] TO [ssc_webapplication]
GO
