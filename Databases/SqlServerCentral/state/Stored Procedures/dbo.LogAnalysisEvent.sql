SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[LogAnalysisEvent]
    @Time DATETIME ,
    @Data VARCHAR(50)
AS 
    DECLARE @RoundedTime DATETIME
    SELECT  @RoundedTime = CONVERT(CHAR(10), @Time, 120)
	
    IF EXISTS ( SELECT  1
                FROM    dbo.AnalysisLog
                WHERE   [Time] = @RoundedTime
                        AND [Data] = @Data ) 
        BEGIN
            UPDATE  dbo.AnalysisLog
            SET     [Count] = [Count] + 1
            WHERE   [Time] = @RoundedTime
                    AND [Data] = @Data
        END
    ELSE 
        BEGIN
            INSERT  INTO dbo.AnalysisLog
                    ( Time, Data, Count )
            VALUES  ( @RoundedTime, @Data, 1 )
        END
	
    SELECT  @@ROWCOUNT AS atatRowCount


GO
GRANT EXECUTE ON  [dbo].[LogAnalysisEvent] TO [ssc_webapplication]
GO
