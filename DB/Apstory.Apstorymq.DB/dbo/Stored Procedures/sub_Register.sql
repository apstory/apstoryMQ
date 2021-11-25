/*=====================Testing==================

declare @RetVal int
declare @RetMsg varchar(50)
exec @RetVal = sub_Register @RetMsg output

select @RetVal, @RetMsg

*/
CREATE PROCEDURE [dbo].[sub_Register]
	@ApplicationId int,
	@Client varchar(255),
	@Topic	varchar(255),
    @RetMsg varchar(255) output
AS
BEGIN
      declare @InitialTransCount int = @@TRANCOUNT     
      declare @TranName varchar(32) = OBJECT_NAME(@@PROCID)

      begin try
            if @InitialTransCount = 0 begin transaction @TranName
                                				
			declare @RetVal	int = 1         
					
			exec @RetVal = sub_SubscriptionLookup @ApplicationId, @Client, @Topic, @RetMsg output
				
			if (@RetVal = 1)
			begin
				set @RetMsg = 'Subscription Failure: ' + @RetMsg
				goto error_section
			end 
									
			exec @RetVal = sub_CreateMessageTable @ApplicationId, @Client, @Topic, @RetMsg output
	  				
			if (@RetVal = 1)
			begin
				set @RetMsg = 'Subscription Failure: ' + @RetMsg
				goto error_section
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