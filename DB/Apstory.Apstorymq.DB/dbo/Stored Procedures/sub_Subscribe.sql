/*=====================Testing==================

declare @RetVal int
declare @RetMsg varchar(50)

exec @RetVal = sub_Subscribe '1234','testclient','testtopic', 1, 100, @retMsg output

select @RetVal, @RetMsg

*/
CREATE PROCEDURE [dbo].[sub_Subscribe]
	@Key			nvarchar(255),
	@Client			varchar(255),
	@Topic			varchar(255),
	@PageNumber		int,
	@PageSize		int,
	@RetMsg			nvarchar(255) output
AS
BEGIN      	 
      declare @InitialTransCount int = @@TRANCOUNT     
      declare @TranName varchar(32) = OBJECT_NAME(@@PROCID)

      begin try
            if @InitialTransCount = 0 begin transaction @TranName  
				
			declare @RetVal int = 1			
			declare @ApplicationId int
			
			exec @RetVal = app_GetKey @Key, @ApplicationId output, @RetMsg output
			if(@RetVal = 1)
			begin
				goto error_section
			end
			
			exec @RetVal = sub_Register @ApplicationId, @Client, @Topic, @RetMsg output
			
			if(@RetVal = 1)
			begin
				goto error_section
			end									    								
			
			EXEC sub_GetMessage @ApplicationId, @Client, @Topic, @PageNumber, @PageSize
            
            --Exit Successful
            if @InitialTransCount = 0 commit transaction @TranName            
            return 0
            
            --Error Section
            error_section:
                  if @InitialTransCount = 0 rollback transaction @TranName                  
                  return 1
      end try
      begin catch
            if @InitialTransCount = 0 rollback transaction @TranName                     
            return 1
      end catch
END