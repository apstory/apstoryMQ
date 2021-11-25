/*=====================Testing==================

declare @RetMsg nvarchar(500)
declare @RetVal int
exec @RetVal = [dbo].[sub_Unsubscribe] '1234','TestHarnessSubscribe','Publish.Test',@RetMsg output
select @RetVal, @RetMsg

*/
CREATE PROCEDURE [dbo].[sub_Unsubscribe] 
	@Key			nvarchar(255),
	@Client			varchar(255),
	@Topic			varchar(255),
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
            
			declare @TableName varchar(255) 
			select @TableName = [dbo].[fun_GetTableName] (@ApplicationId,@Client,@Topic)

            delete from dbo.[Subscription] where ApplicationId = @ApplicationId and Client = @Client and Topic = @Topic

			declare @DoesTableExists bit = 0
			select @DoesTableExists = dbo.[fun_CheckIfTableExists] (@ApplicationId, @TableName)
			if(@DoesTableExists = 1)
			begin
				declare @sql varchar(255)
				set @sql = 'drop table ' + @TableName + ''
				exec(@sql)
			end
            
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