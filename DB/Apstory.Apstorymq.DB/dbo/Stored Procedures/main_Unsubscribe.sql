/*=====================Testing==================

*/
CREATE PROCEDURE [dbo].[main_Unsubscribe] 
	@ApplicationId int,
	@Client varchar(255),
	@Topic varchar(255),
    @RetMsg varchar(50) output    
AS
BEGIN
      declare @InitialTransCount int = @@TRANCOUNT     
      declare @TranName varchar(32) = OBJECT_NAME(@@PROCID)

      begin try
            if @InitialTransCount = 0 begin transaction @TranName
            
            declare @TableName varchar(255)
			set @TableName = [dbo].[fun_GetTableName](@ApplicationId,@Client, @Topic)
			
			declare @sql varchar(255)
			set @sql = 'drop table [' + @TableName + ']'            
            
            delete Subscription where Topic = @Topic and @Client = Client and ApplicationId = @ApplicationId
            exec (@sql) 
            
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