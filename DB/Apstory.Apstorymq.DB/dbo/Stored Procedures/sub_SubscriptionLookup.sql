/*=====================Testing==================

declare @RetVal int
declare @RetMsg varchar(50)
exec @RetVal = sub_SubscriptionLookup @RetMsg output

select @RetVal, @RetMsg

*/
CREATE PROCEDURE [dbo].[sub_SubscriptionLookup] 
	@ApplicationId int,
	@Client varchar(255),
	@Topic varchar(255),		
	@RetMsg varchar(255) output  
AS
BEGIN
      declare @InitialTransCount int = @@TRANCOUNT     
      declare @TranName varchar(32) = OBJECT_NAME(@@PROCID)

      begin try
            if @InitialTransCount = 0 begin transaction @TranName
 
            if not exists(select 1 SubscriptionId from Subscription where ApplicationId = @ApplicationId and Client = @Client and Topic = @Topic)
            begin
				insert Subscription (ApplicationId, Client, Topic)
				values (@ApplicationId, @Client, @Topic)
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