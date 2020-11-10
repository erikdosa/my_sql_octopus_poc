SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[LogUtilityEvent]
    @Date [datetime] ,
    @Thread [varchar](255) ,
    @Level [varchar](50) ,
    @Logger [varchar](255) ,
    @Message [varchar](4000) ,
    @Exception [varchar](2000)
AS 
    INSERT  INTO dbo.UtilitiesLog
            ( Date ,
              Thread ,
              Level ,
              Logger ,
              Message ,
              Exception
            )
    VALUES  ( @Date ,
              @Thread ,
              @Level ,
              @Logger ,
              @Message ,
              @Exception
            )

GO
GRANT EXECUTE ON  [dbo].[LogUtilityEvent] TO [ssc_rssimporter]
GO
GRANT EXECUTE ON  [dbo].[LogUtilityEvent] TO [ssc_searchindexer]
GO
