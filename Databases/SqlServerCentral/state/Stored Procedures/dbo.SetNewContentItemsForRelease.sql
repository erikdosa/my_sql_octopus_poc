SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[SetNewContentItemsForRelease]
   @ContentItemID int
 , @ReleaseDate datetime
as

insert ContentItemsScheduledRelease 
 select @ContentItemID
   , @ReleaseDate
   , 0

return

GO
