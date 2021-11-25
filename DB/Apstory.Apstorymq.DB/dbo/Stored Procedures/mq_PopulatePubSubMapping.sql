/*=====================Testing==================


*/
CREATE PROCEDURE [dbo].[mq_PopulatePubSubMapping]
	@PubClient			varchar(255),
	@PubTopic			varchar(255),
	@SubClient			varchar(255),
	@SubTopic			varchar(255),
	@SubscriptionId		INT,
	@RetMsg VARCHAR(255) output
AS
BEGIN

	begin try
		declare @PubSubMappingId int 
		select top 1 @PubSubMappingId = PubSubMappingId 
		from PubSubMapping with(nolock)
		where SubscriptionId = @SubscriptionId and PubClient = @PubClient and PubTopic = @PubTopic

		if(@PubSubMappingId is null)
		BEGIN
			INSERT INTO PubSubMapping (PubClient, PubTopic, SubClient, SubTopic, CreateDT, LastPublishDT, SubscriptionId)
			VALUES(@PubClient, @PubTopic, @SubClient, @SubTopic, GETDATE(), GETDATE(), @SubscriptionId)
		END
		ELSE
		BEGIN
			UPDATE PubSubMapping WITH(ROWLOCK) set LastPublishDT = GETDATE() where PubSubMappingId = @PubSubMappingId
		END 

		return 0
	end try
	begin catch
		set @RetMsg = ERROR_MESSAGE()
		return 1 
	end catch
END