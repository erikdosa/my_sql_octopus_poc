SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Email_UnsubscribeAfterExcessiveBounces] 
AS
BEGIN
	DELETE FROM [SingleSignon].dbo.MemberRoles WHERE [ID] IN
	(
		SELECT DISTINCT mr.ID
		FROM [SingleSignon].dbo.MemberRoles mr
		JOIN [SingleSignon].dbo.Members m ON m.ID=mr.MemberID
		JOIN
			(
			SELECT nbl.EmailAddress, mr.RoleName, nbl.BounceType, COUNT(*) BounceCount, nut.Threshold
			FROM dbo.NewsletterBounceLog nbl
			LEFT JOIN SingleSignon..Members mbr 
				ON mbr.EmailAddress = nbl.EmailAddress
			LEFT JOIN SingleSignon..MemberRoles mr 
				ON mbr.ID = mr.MemberID
			LEFT JOIN dbo.NewsletterUnsubscribeThresholds nut
				ON 'SSC.' + nut.EmailTypeName = mr.RoleName AND nut.BounceType = nbl.BounceType
			WHERE mr.RoleName IN ('SSC.NewsletterSubscriber', 'SSC.DatabaseWeeklySubscriber')
				AND nbl.[Date] > DATEADD(DAY, -1 * nut.DaysWindow, GETDATE())
			GROUP BY 
				nbl.EmailAddress, mr.RoleName, nbl.BounceType, nut.Threshold
			HAVING COUNT(*) >= nut.Threshold	
			) bouncedTooOftenRecords ON bouncedTooOftenRecords.EmailAddress = m.UserName
		WHERE mr.RoleName IN ('SSC.NewsletterSubscriber', 'SSC.DatabaseWeeklySubscriber')
	)
END







GO
