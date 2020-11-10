SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetMostRecentBlogPosts]
	@MaxResults AS INT = 60
AS
	-- This query was initially salvaged from a SQL Server profiler trace
	
	-- I retrieved most of the information in the comments
	-- by looking at the CS source in Reflector to try
	-- to understand the bit masked values
    SELECT TOP ( @MaxResults )
            p.Subject ,
            p.PostDate ,
            p.Body ,
            p.FormattedBody ,
            p.PostName ,
            s.[Name] AS 'BlogName' ,
            s.ApplicationKey AS 'BlogID' ,
            p.UserID ,
            p.IsApproved AS 'IsPublished' ,
            p.PostID
    FROM    CommunityServer.dbo.cs_Sections s
            INNER JOIN CommunityServer.dbo.cs_Posts p
				ON s.SectionID = p.SectionID
    WHERE   s.ApplicationType = 1 AND --  Forum = 0, Weblog = 1, Gallery = 2, GuestBook = 3
            p.ApplicationPostType = 1 -- posts = 1, articles = 2, comments = 4, trackbacks = 8
--		p.PostConfiguration & 1 = 1   -- Empty = 0, IsAggregated = 1, IsCommunityAggregated = 2, SyndicateExcerpt = 4
--		p.IsApproved = 1              -- published = 1, saved but not published = 0
--		p.PostDate <= GETDATE()
    ORDER BY p.PostDate DESC
	-- PS - I hate Community Server

GO
GRANT EXECUTE ON  [dbo].[GetMostRecentBlogPosts] TO [ssc_webapplication]
GO
