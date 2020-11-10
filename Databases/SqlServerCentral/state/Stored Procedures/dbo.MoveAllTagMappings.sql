SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[MoveAllTagMappings] 
	@FromTagText nvarchar(100),
	@ToTagID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- Moving tag mappings to themselves should do nothing
	IF NOT EXISTS(SELECT * FROM Tags where TagID=@ToTagID and TagText=@FromTagText)
	BEGIN
		-- Don't move tagmappings when the same tag/contentitem pair already exists
		UPDATE tm
		SET tm.TagID = @ToTagID
		FROM [TagMappings] tm
		JOIN Tags t ON t.[TagID]=tm.[TagID]
		LEFT OUTER JOIN [TagMappings] tm_existing 
			ON [tm_existing].[TagID] = @toTagID
			AND [tm_existing].[ContentItemID] = tm.[ContentItemID]
		WHERE t.[TagText]=@FromTagText
		AND [tm_existing].[TagMappingID] IS NULL

		-- Erase any that were left because the same tag/contentitem pair already exists
		DELETE FROM [TagMappings] 
		WHERE [TagID] IN (SELECT TagID FROM [Tags] WHERE [TagText]=@FromTagText)
	END
END

GO
GRANT EXECUTE ON  [dbo].[MoveAllTagMappings] TO [ssc_webapplication]
GO
