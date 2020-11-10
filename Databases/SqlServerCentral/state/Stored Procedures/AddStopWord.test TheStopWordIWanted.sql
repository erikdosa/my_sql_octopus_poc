SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--  Comments here are associated with the test.
--  For test case examples, see: http://tsqlt.org/user-guide/tsqlt-tutorial/
CREATE PROCEDURE [AddStopWord].[test TheStopWordIWanted]
AS

BEGIN

-- Create a fake table
EXEC tSQLt.FakeTable 'dbo.SearchAnalyzerConfig';

-- Populate a record using the procedure I'm testing
EXEC dbo.AddStopWord @Word = N'TheStopWordIWanted'

-- Specify the actual results
DECLARE @ActualWord CHAR(50);
SET @ActualWord = (SELECT Word FROM dbo.SearchAnalyzerConfig);

-- Verify that the actual results corresponds to the expected results
EXEC tSQLt.AssertEquals @Expected = 'TheStopWordIWanted', @Actual = @ActualWord;

END;

GO
