SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[SetScheduledItemsForRelease]
  @releasedate datetime
as
declare @DateToRelease datetime

select @DateToRelease = cast( cast( year( @releasedate) as varchar(4)) + '-'
                              + cast( month(@releasedate) as varchar(2)) + '-'
                              + cast( day(@releasedate) as varchar(2))
						as datetime)
Update CI
 set PublishingStatus = 30
 from ContentItems CI
	inner join ContentItemsScheduledRelease CISR
		on CI.ContentItemID = CISR.ContentItemID
 where CISR.released = 0
 and CISR.releasedate = @datetorelease

return

GO
