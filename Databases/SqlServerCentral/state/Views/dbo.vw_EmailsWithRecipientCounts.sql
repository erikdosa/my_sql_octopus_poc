SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vw_EmailsWithRecipientCounts]
AS
WITH EmailData AS 
(
    SELECT  e.EmailID, 
            nrc.RecipientCount AS CountTotalRecipients, 
            SUM(CASE WHEN er.SentDate IS NULL THEN 0 ELSE 1 END) AS CountSentRecipients
    FROM    dbo.Emails AS e LEFT OUTER JOIN
            dbo.EmailRecipients AS er ON er.EmailID = e.EmailID LEFT OUTER JOIN
            dbo.NewsletterRecipientCounts AS nrc ON nrc.EmailID = e.EmailID
    GROUP BY e.EmailID, nrc.RecipientCount
)
    SELECT  e.EmailID, e.RecordType, e.EmailTypeName, e.IsTest, e.UseClickTracking, e.SubjectText, e.BodyHTML, e.BodyPlainText, e.SenderName, e.SenderEmailAddress, 
            e.Status, e.ScheduleForDate, e.ApprovedForSending, ed.CountTotalRecipients, ed.CountSentRecipients
     FROM   dbo.Emails AS e INNER JOIN
            EmailData AS ed ON ed.EmailID = e.EmailID

GO
GRANT DELETE ON  [dbo].[vw_EmailsWithRecipientCounts] TO [ssc_webapplication]
GO
GRANT INSERT ON  [dbo].[vw_EmailsWithRecipientCounts] TO [ssc_webapplication]
GO
GRANT SELECT ON  [dbo].[vw_EmailsWithRecipientCounts] TO [ssc_webapplication]
GO
GRANT UPDATE ON  [dbo].[vw_EmailsWithRecipientCounts] TO [ssc_webapplication]
GO
