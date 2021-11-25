/*=====================Testing==================

select * from dbo.fun_GetSubscriptionsByTopicClient (1,'testclient','testtopic')

*/

CREATE FUNCTION [dbo].[fun_GetSubscriptionsByTopicClient]
(	
	@ApplicationId	int,
	@Client			varchar(255),
	@Topic			varchar(255)
)
RETURNS 
@tbl_Subscriptions TABLE 
(	
	SubscriptionId		int,
	ApplicationId		int,
	SubscriptionClient	varchar(255),
	SubscriptionTopic	varchar(255),
	IsPublished			bit
)
AS
BEGIN
		
	insert into @tbl_Subscriptions
	select SubscriptionId, ApplicationId, Client, Topic, 0 from Subscription
	where (ApplicationId = @ApplicationId and Topic = @Topic) 
	or (ApplicationId = @ApplicationId and @Topic like dbo.fun_ConvertTopicWildcard(Topic))
		
	RETURN
END
