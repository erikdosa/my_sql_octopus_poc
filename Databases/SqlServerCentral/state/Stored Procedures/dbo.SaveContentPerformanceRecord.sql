SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SaveContentPerformanceRecord] 
@ContentItemID INT = NULL,
@ID INT = NULL,
@ViewCount INT = NULL,
@DirtyViewCount INT = NULL,
@TotalRatings INT = NULL, 
@UserRating FLOAT = -1, 
@DirtyTotalRatings INT = NULL,
@Delete INT = NULL
AS
BEGIN
IF @Delete = 1 -- pure delete
BEGIN
	DELETE FROM ContentPerformanceRecord WHERE ContentItemID = @ContentItemID
	RETURN
END

IF @ID IS NOT NULL -- update - incrementing viewcount, rating
BEGIN

	-- views
	DECLARE @newViews INT
	SET @newViews = @DirtyViewCount - @ViewCount

	IF(@newViews > 0)
		UPDATE   ContentPerformanceRecord
		SET      CountOfViews = CountOfViews + @newViews,
				TotalViews = TotalViews + @newViews,
				ViewsLastNDays = ViewsLastNDays + @newViews
		WHERE    ContentPerformanceRecordID = @ID

	-- ratings
	DECLARE @ratingCount INT
	SET @ratingCount = @DirtyTotalRatings - @TotalRatings 

	IF( @ratingCount > 0)
		UPDATE ContentPerformanceRecord
		SET TotalRatings = TotalRatings + (@ratingCount),
			AverageRating = (AverageRating * TotalRatings + @UserRating * @ratingCount)/(TotalRatings + (@ratingCount))  
		WHERE    ContentPerformanceRecordID = @ID

END
ELSE IF @ContentItemID IS NOT NULL --insert
BEGIN

	DECLARE @maxDay INT
	SELECT @maxDay = isnull(MAX(Day), 0) FROM ContentPerformanceRecord

	IF NOT EXISTS (SELECT 1 FROM ContentPerformanceRecord 
					WHERE Day = @maxDay 
					AND ContentItemID = @ContentItemID) 	
	INSERT INTO ContentPerformanceRecord(ContentItemID, Day) VALUES(@ContentItemID, @maxDay)

END

END



GO
GRANT EXECUTE ON  [dbo].[SaveContentPerformanceRecord] TO [ssc_webapplication]
GO
