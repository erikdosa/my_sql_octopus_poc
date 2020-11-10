SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[LogEvent] 
@Time DATETIME, 
@Url  NVARCHAR(300) = NULL, 
@Ip   VARCHAR(18) = NULL, 
@Event VARCHAR(50) = NULL,
@Description NVARCHAR(300) = NULL, 
@ErrorCode INT = NULL,
@Trace VARCHAR(MAX) = NULL, 
@TraceHash INT = NULL,
@Headers NVARCHAR(MAX) = NULL, 
@UserID INT = -1
AS
BEGIN

INSERT INTO EventLog (
	[Time],
	Event,
	Description,
	ErrorCode,
	Url,
	RequestIP,
	StackTrace,
	StackTraceHash,
	Headers,
	UserID
) VALUES (
	@Time,
	@Event,
	@Description,
	@ErrorCode,
	@Url,
	@Ip,
	@Trace,
	@TraceHash,
	@Headers,
	@UserID 
) 

SELECT SCOPE_IDENTITY() AS EventID

END

GO
GRANT EXECUTE ON  [dbo].[LogEvent] TO [Emailer]
GO
GRANT EXECUTE ON  [dbo].[LogEvent] TO [ssc_webapplication]
GO
