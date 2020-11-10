SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[TopScores] 
	-- Add the parameters for the stored procedure here
	@CutoffDate SMALLDATETIME, --updated from DATETIME
	@PointsCategory INT,
	@AdditionalUser INT,
	@MaxResults INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

IF @PointsCategory IS NULL
BEGIN
	WITH
	cteTotal AS
	(--==== Create the required sums for each UserID.  Additional user will NOT show up if
		 -- no points for category within cut off date.
	 SELECT UserID,
			RecentPoints = SUM(CASE WHEN Date >= @CutoffDate THEN PointsScored ELSE 0 END),
			AllPoints    = SUM(PointsScored)
	   FROM dbo.UserPoints
	  WHERE UserID <> 57832
	  GROUP BY UserID
	)
	,
	cteRowNum AS
	(--==== Now, add the row number so we can pick the max results
	 SELECT RowNum = ROW_NUMBER() OVER (ORDER BY RecentPoints Desc),
			UserID,
			RecentPoints,
			AllPoints
	   FROM cteTotal
	)--==== Return the max results and the additional user id if there is one
	 SELECT rn.RowNum AS RowNumber, u.UserID, u.DisplayName, rn.RecentPoints, rn.AllPoints
	   FROM cteRowNum rn
	  INNER JOIN dbo.Users u
		 ON u.UserID = rn.UserID
	  WHERE (rn.RowNum <= @MaxResults OR rn.UserID = @AdditionalUser)
	  ORDER BY rn.RowNum
END ELSE BEGIN
	WITH
	cteTotal AS
	(--==== Create the required sums for each UserID.  Additional user will NOT show up if
		 -- no points for category within cut off date.
	 SELECT UserID,
			RecentPoints = SUM(CASE WHEN Date >= @CutoffDate THEN PointsScored ELSE 0 END),
			AllPoints    = SUM(PointsScored)
	   FROM dbo.UserPoints
	  WHERE PointsCategory = @PointsCategory AND UserID <> 57832
	  GROUP BY UserID
	)
	,
	cteRowNum AS
	(--==== Now, add the row number so we can pick the max results
	 SELECT RowNum = ROW_NUMBER() OVER (ORDER BY RecentPoints Desc),
			UserID,
			RecentPoints,
			AllPoints
	   FROM cteTotal
	)--==== Return the max results and the additional user id if there is one
	 SELECT rn.RowNum AS RowNumber, u.UserID, u.DisplayName, rn.RecentPoints, rn.AllPoints
	   FROM cteRowNum rn
	  INNER JOIN dbo.Users u
		 ON u.UserID = rn.UserID
	  WHERE (rn.RowNum <= @MaxResults OR rn.UserID = @AdditionalUser)
	  ORDER BY rn.RowNum
END
  
END

GO
GRANT EXECUTE ON  [dbo].[TopScores] TO [ssc_webapplication]
GO
