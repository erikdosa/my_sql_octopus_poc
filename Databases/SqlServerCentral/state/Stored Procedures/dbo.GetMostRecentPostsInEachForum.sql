SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[GetMostRecentPostsInEachForum] 
	@MaxResults as int = 5
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	/* First reduce the search space to the 100 most recent posts */
	/* Theoretically this could lead to inaccurate results (if virtually all  
		recent posts are in the same forum) but it's very unlikely and is 
		a trade-off against speed. Change or remove the "top 100" clause 
		to adjust the speed/accuracy tradeoff. Before this optimisation the
		query was taking 2 seconds, which is too long. */
	; WITH RecentTopics (TopicID, ForumID, DateStamp) AS (
		SELECT TOP 100 topic.TopicID, topic.ForumID, topic.DateStamp
		FROM SqlServerCentralForums.dbo.InstantForum_Topics topic
		JOIN SqlServerCentralForums.dbo.InstantForum_Messages msg ON msg.PostID = topic.PostID
		WHERE NOT(msg.Message LIKE 'Comments posted %')
		ORDER BY topic.DateStamp DESC
	)
	/* Among those 100 posts, group by forum and pick out the most recent by forum */
	, MostRecentInForum (ForumID, DateStamp) AS (
		SELECT TOP (@MaxResults) forum.ForumID, MAX(rt.DateStamp) AS DateStamp FROM RecentTopics rt
		JOIN SqlServerCentralForums.dbo.InstantForum_Forums forum ON forum.ForumID = rt.ForumID
		GROUP BY forum.ForumID
		ORDER BY MAX(rt.DateStamp) DESC
	)
	/* Finally, return all the data we need for each chosen post */
	SELECT 		
			forum.[ForumID] AS ForumID,
			forum.[Name] AS ForumName,
			origial_post_in_topic.TopicID as TopicID,
			origial_post_in_topic.Title as TopicName,
			topic.PostID,
			topic.Title,
			topic.DateStamp,
			usr.UserID,
			usr.Username,
			msg.Message
	FROM SqlServerCentralForums.dbo.InstantForum_Topics topic
	JOIN MostRecentInForum mrf ON mrf.ForumID = topic.ForumID AND mrf.DateStamp = topic.DateStamp
	JOIN SqlServerCentralForums.dbo.InstantForum_Topics origial_post_in_topic on origial_post_in_topic.ParentID=0 and origial_post_in_topic.TopicID=topic.TopicID
	JOIN SqlServerCentralForums.dbo.InstantASP_Users usr ON usr.UserID = topic.UserID
	JOIN SqlServerCentralForums.dbo.InstantForum_Messages msg ON msg.PostID = topic.PostID
	JOIN SqlServerCentralForums.dbo.InstantForum_Forums forum ON forum.ForumID = topic.ForumID
	ORDER BY topic.DateStamp DESC
END


GO
GRANT EXECUTE ON  [dbo].[GetMostRecentPostsInEachForum] TO [ssc_webapplication]
GO
