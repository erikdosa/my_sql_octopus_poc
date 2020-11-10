SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROC [dbo].[Email_NewsletterLogBounce]
    @EmailAddress VARCHAR(255) ,
    @BounceType INT
AS 
    IF ( NOT EXISTS ( SELECT    1
                      FROM      dbo.NewsletterBounceLog
                      WHERE     EmailAddress = @EmailAddress
                                AND BounceType = @BounceType
                                AND [Date] > DATEADD("d", -1, GETDATE()) )
       ) 
        BEGIN
	                                          	
            INSERT  INTO dbo.NewsletterBounceLog
                    ( EmailAddress, BounceType )
            VALUES  ( @EmailAddress, @BounceType )
        END

GO
GRANT EXECUTE ON  [dbo].[Email_NewsletterLogBounce] TO [Emailer]
GO
GRANT EXECUTE ON  [dbo].[Email_NewsletterLogBounce] TO [ssc_emailer]
GO
