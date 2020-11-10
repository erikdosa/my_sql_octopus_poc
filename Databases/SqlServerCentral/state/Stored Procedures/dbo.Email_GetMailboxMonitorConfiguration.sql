SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Email_GetMailboxMonitorConfiguration]
AS  
    SELECT  ID,
            MailboxAddress,
            MailboxPassword,
            MailServer,
            AccountType
    FROM    dbo.MailboxMonitorConfiguration
    ORDER BY AccountType DESC 


GO
GRANT EXECUTE ON  [dbo].[Email_GetMailboxMonitorConfiguration] TO [Emailer]
GO
GRANT EXECUTE ON  [dbo].[Email_GetMailboxMonitorConfiguration] TO [ssc_emailer]
GO
