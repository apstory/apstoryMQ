/*=====================Testing==================

declare @RetVal int
declare @RetMsg varchar(255)
declare @MessageId int

declare @body varbinary(MAX)
set @body = CAST('Test' as varbinary)

exec @RetVal = pub_PublishMessage 1,'testclient', 'testtopic', @body, @RetMsg output

select @RetVal, @RetMsg, @MessageId

*/
CREATE PROCEDURE [dbo].[pub_PublishMessage]		
		@Key			nvarchar(255),	
		@Client			nvarchar(255),
		@Topic			nvarchar(255),
		@Body			VARBINARY(MAX),
		@Properties		NVARCHAR(MAX) = null,
		@RetMsg			nvarchar(255) output
AS
BEGIN
      declare @InitialTransCount int = @@TRANCOUNT     
      declare @TranName varchar(32) = OBJECT_NAME(@@PROCID)

      begin try
            if @InitialTransCount = 0 begin transaction @TranName
            
            declare @RetVal				int = 1            
			declare @SubscriptionId		int
			declare @SubscriptionClient varchar(255)
			declare @SubscriptionTopic	varchar(255)			
			
			declare @tmpSubscriptions TABLE(
				SubscriptionId		int NOT NULL PRIMARY KEY,
				SubscriptionClient	varchar(255),
				SubscriptionTopic	varchar(255),
				IsPublished			BIT DEFAULT (0)
			);

			declare @ApplicationId int
			
			exec @RetVal = app_GetKey @Key, @ApplicationId output, @RetMsg output
			if(@RetVal = 1)
			begin
				goto error_section
			end

			INSERT INTO @tmpSubscriptions (SubscriptionId,SubscriptionClient,SubscriptionTopic,IsPublished)
			select SubscriptionId,SubscriptionClient,SubscriptionTopic,IsPublished
			from dbo.fun_GetSubscriptionsByTopicClient (@ApplicationId,@Client,@Topic)
					
			while exists (select 1 from @tmpSubscriptions where IsPublished = 0)
			begin				
				
				select top 1
					@SubscriptionId = SubscriptionId,
					@SubscriptionClient = SubscriptionClient,
					@SubscriptionTopic = SubscriptionTopic
				from 
					@tmpSubscriptions
				where
					IsPublished = 0
				
				exec @RetVal = pub_InsertMessage @ApplicationId,@SubscriptionClient,@SubscriptionTopic, 
							   @Topic,@Body,@Properties,@RetMsg output
							   
				if (@RetVal = 1)
				begin
					set @RetMsg =	'Failed to publish to table: ' + 
									dbo.fun_GetTableName(@ApplicationId,@SubscriptionClient, @SubscriptionTopic) + 
									' Error: ' + @RetMsg
					goto error_section
				end

				update @tmpSubscriptions set IsPublished = 1 where SubscriptionId = @SubscriptionId			
					
				exec mq_PopulatePubSubMapping @Client, @Topic, @SubscriptionClient, @SubscriptionTopic, @SubscriptionId, @RetMsg output

			end
            
            --Exit Successful
            if @InitialTransCount = 0 commit transaction @TranName
            set @RetMsg = 'Successful'
            return 0
            
            --Error Section
            error_section:
                  if @InitialTransCount = 0 rollback transaction @TranName                  
                  return 1
      end try
      begin catch
            if @InitialTransCount = 0 rollback transaction @TranName
            set @RetMsg = ERROR_MESSAGE()                        
            return 1
      end catch
END