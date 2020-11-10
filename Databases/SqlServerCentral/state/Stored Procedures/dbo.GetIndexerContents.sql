SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[GetIndexerContents]
AS 
    BEGIN
        SELECT  ci.ContentItemID,
				ci.Title,
				ci.Description,
				ci.Text,
				ci.CreatedDate,
				ci.LastModifiedDate,
				blog.Slug AS BlogSlug,
				blogPost.PublicationDate AS BlogPostPublicationDate,
				blogPost.Slug AS BlogPostSlug,
				CASE
					WHEN u.AuthorFullName IS NOT NULL AND u.DisplayName != u.AuthorFullName
					THEN u.DisplayName + ' ' + u.AuthorFullName
					ELSE u.DisplayName
				END AS 'Author',
				CASE
					WHEN a.ContentItemID IS NOT NULL THEN 'article'
					WHEN s.ContentItemID IS NOT NULL THEN 'script'
					WHEN blogPost.ContentItemID IS NOT NULL THEN 'blogPost'
				END AS 'Type'
		FROM    dbo.ContentItems ci
				LEFT OUTER JOIN dbo.Articles a
					ON ci.ContentItemID = a.ContentItemID
				LEFT OUTER JOIN dbo.Scripts s
					ON ci.ContentItemID = s.ContentItemID
				LEFT OUTER JOIN dbo.BlogPosts AS blogPost
					ON ci.ContentItemID = blogPost.ContentItemID
				LEFT OUTER JOIN dbo.Blogs AS blog
					ON blogPost.BlogId = blog.Id
				LEFT outer JOIN dbo.AuthorContentItem ac
					ON ci.ContentItemID = ac.ContentItemID
				LEFT OUTER JOIN dbo.Users u
					ON ac.UserID = u.UserID
		WHERE   (a.ContentItemID IS NOT NULL OR s.ContentItemID IS NOT NULL OR blogPost.ContentItemID IS NOT null)
				AND ci.PublishingStatus = 30
				-- Ignore some articles with certain tags
				AND NOT EXISTS ( SELECT 1
								 FROM   dbo.TagMappings t
								 WHERE  t.ContentItemID = ci.ContentItemID
										AND t.TagID IN ( 1781,	--	Editorial - IPOD
														 1782,	--	Editorial - MP3
														 1821 ) --	Editorial - WMV
							)
				-- Ignore redirects
				AND ci.ExternalURL IS NULL
    END

GO
GRANT EXECUTE ON  [dbo].[GetIndexerContents] TO [ssc_searchindexer]
GO
