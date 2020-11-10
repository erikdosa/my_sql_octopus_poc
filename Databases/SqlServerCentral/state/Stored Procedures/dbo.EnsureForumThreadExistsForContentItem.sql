SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[EnsureForumThreadExistsForContentItem] 
	@contentItemID INT,				-- Content item in question
	@authorUserID INT,				-- There may be multiple authors. Indicate which one gets it in their personal forum.
	@authorName NVARCHAR(MAX),		-- Under what name does the author wish to be known?
	@contentItemURL NVARCHAR(MAX)	-- At what URL can the content item be found?
AS
BEGIN
	DECLARE @ArticleDiscussionsRootForumID INT
	DECLARE @DiscussionThreadsStartedByInstantForumsUserID INT
	DECLARE @AnonymousContentForumID INT
	DECLARE @EditorialsForumID INT
	DECLARE @EditoralTagText VARCHAR(50)
	DECLARE @FoundInstantForumsUserIDForAuthor INT

	SET XACT_ABORT ON

	-- ********* EDIT THESE VALUES to make consistent with your data ***********
	SET @ArticleDiscussionsRootForumID = 633
	SET @DiscussionThreadsStartedByInstantForumsUserID = 62271
	SET @AnonymousContentForumID = 34
	SET @EditorialsForumID = 263
	SET @EditoralTagText = 'Editorial' -- How to identify editorials
	SET @FoundInstantForumsUserIDForAuthor = NULL -- Will be set later if possible

	BEGIN TRAN
		-- If the author has an InstantForums user account, start the thread under their identity
		SELECT @DiscussionThreadsStartedByInstantForumsUserID = UserID,
				@FoundInstantForumsUserIDForAuthor = UserID
		FROM [SqlServerCentralForums].dbo.[InstantASP_Users]
		WHERE (SSCUserID = @authorUserID) AND (@authorUserID IS NOT NULL)

		DECLARE @TargetForumID int

		-- Content with primary tag "Editorial" should go into the "Editorials" forum
		IF EXISTS(SELECT 1 FROM [ContentItems] ci JOIN [Tags] t ON t.[TagID]=ci.[PrimaryTagID] WHERE ci.[ContentItemID]=@contentItemID AND t.[TagText]=@EditoralTagText)
		BEGIN
			SET @TargetForumID = @EditorialsForumID
		END
		ELSE
		BEGIN
			-- It's not an editorial, so try to find the forum for this author
			IF @authorUserID IS NOT NULL
			BEGIN
				-- Ensure the author has a forum for their content discussions
				SELECT @TargetForumID=[AuthorForumID] FROM [Users] u WITH(XLOCK) WHERE u.[UserID]=@authorUserID
		
				IF @TargetForumID IS NULL
				BEGIN
					DECLARE @forumTitle NVARCHAR(MAX)
					DECLARE @forumDescription NVARCHAR(MAX)
					SELECT @forumTitle = 'Discuss content posted by ' + @authorName
					SELECT @forumDescription = 'Discussions about content posted by ' + @authorName
					EXEC SqlServerCentralForums.dbo.[if_sp_InsertUpdateForum]
						@intForumID = 0, 
						@intParentID = @ArticleDiscussionsRootForumID,
						@intWrapperID = 0, 
						@strSkin = '', 
						@strName = @forumTitle,
						@strDescription = @forumDescription, 
						@strForumNotes = NULL, 
						@bitExpanded = 1,
						@bitAllowTopics = 1,
						@bitAllowSearching = 0,
						@bitIncreaseMemberPostCount = 1, 
						@strRedirectURL = '',
						@intRedirectClicks = 0, 
						@strRedirectTarget = '',
						@intDefaultDateFilter = 1, 
						@intDefaultSortBy = 1, 
						@intDefaultSortOrder = 1, 
						@intDisplayMode = 1, 
						@intTopicsPerPage = 15, 
						@intMessagesPerPage = 10,
						@intModerateType = 1,
						@bitIsCategory = 0,
						@bitClosedForum = 0,
						@intIdentity = @TargetForumID OUTPUT
					UPDATE Users SET [AuthorForumID]=@TargetForumID WHERE [UserID]=@authorUserID

					-- Give forum members permission to see it
					EXEC SqlServerCentralForums.dbo.[if_sp_InsertForumRoleRelationship]
						@intForumID = @TargetForumID,
						@intRoleID = 2,
						@intPermissionID = 0
					-- Also make it browsable by anonymous users
					EXEC SqlServerCentralForums.dbo.[if_sp_InsertForumRoleRelationship]
						@intForumID = @TargetForumID,
						@intRoleID = 7,
						@intPermissionID = 0
					-- Copy all moderator records from the parent forum
					INSERT INTO [SqlServerCentralForums].dbo.[InstantForum_ForumsModerators] ([ForumID],	[UserID], [ApproveTopics],	[ApprovePosts],	[EditTopics], [EditPosts],	[DeleteTopics],	[DeletePosts],	[PinTopics], [UnpinTopics],	[LockTopics],	[UnlockTopics],	[MoveTopics],	[UnmoveTopics],	[QueueTopics],	[QueuePosts], 	[OpenPolls],	[ClosePolls],	[ShowIPAddress],[EmailForNewTopics],[EmailForNewPosts],	[EmailForEditedPosts]) 
					SELECT @TargetForumID,	ifm.[UserID], ifm.[ApproveTopics],	ifm.[ApprovePosts],	ifm.[EditTopics], ifm.[EditPosts],	ifm.[DeleteTopics],	ifm.[DeletePosts],	ifm.[PinTopics], ifm.[UnpinTopics],	ifm.[LockTopics],	ifm.[UnlockTopics],	ifm.[MoveTopics],	ifm.[UnmoveTopics],	ifm.[QueueTopics],	ifm.[QueuePosts], 	ifm.[OpenPolls],	ifm.[ClosePolls],	ifm.[ShowIPAddress],ifm.[EmailForNewTopics],ifm.[EmailForNewPosts],	ifm.[EmailForEditedPosts]
					FROM [SqlServerCentralForums].dbo.[InstantForum_ForumsModerators] ifm
					JOIN [SqlServerCentralForums].dbo.[InstantForum_Forums] f ON f.[ForumID]=@TargetForumID AND ifm.[ForumID]=f.[ParentID]
				END
			END
			ELSE
			BEGIN
				-- If the content item has no author
				SELECT @TargetForumID = @AnonymousContentForumID
			END
		END

		-- Now ensure there's a thread for this item
		DECLARE @ContentItemForumThreadID INT
		SELECT @ContentItemForumThreadID = [ForumThreadID] FROM [ContentItems] WITH(XLOCK) WHERE [ContentItemID]=@contentItemID
		IF @ContentItemForumThreadID IS NULL
		BEGIN
			DECLARE @contentItemTitle NVARCHAR(300)
			SELECT @contentItemTitle = (CASE WHEN LEN([Title]) > 250 THEN SUBSTRING([Title],0,250) ELSE [Title] END) FROM [ContentItems] WHERE [ContentItemID]=@contentItemID
			DECLARE @message NVARCHAR(MAX)
			SELECT @message = 'Comments posted to this topic are about the item [B]<A HREF="' + @contentItemURL + '">' + @contentItemTitle + '</A>[/B]'

			-- Create the thread for the content item
			EXEC SqlServerCentralForums.dbo.[if_sp_InsertPost]
				@intForumID = @TargetForumID,
				@intTopicID = 0,
				@intParentID = 0,
				@intUserID = @DiscussionThreadsStartedByInstantForumsUserID,
				@strMessageIcon = '',
				@strTitle = @contentItemTitle,
				@strDescription = '',
				@strMessage = @message,
				@bitForumModerated = 0,
				@bitIsPoll = 0,
				@strIPAddress = '',
				@intIdentity = @ContentItemForumThreadID OUTPUT

			-- Associate the content item with the thread
			UPDATE [ContentItems] SET [ForumThreadID]=@ContentItemForumThreadID WHERE [ContentItemID]=@contentItemID

			-- Subscribe the author to recieve notifications for new posts to the thread
			IF @FoundInstantForumsUserIDForAuthor IS NOT NULL
			BEGIN
				EXEC [SQLServerCentralForums].dbo.[if_sp_InsertTopicSubscription]
					@intUserID = @FoundInstantForumsUserIDForAuthor,
					@intTopicID = @ContentItemForumThreadID,
					@intSubscriptionType = 4 -- This means "immediate email notification"
			END
		END

		SELECT @ContentItemForumThreadID as TopicID, @TargetForumID as ForumID

	COMMIT TRAN
END

GO
GRANT EXECUTE ON  [dbo].[EnsureForumThreadExistsForContentItem] TO [ssc_webapplication]
GO
