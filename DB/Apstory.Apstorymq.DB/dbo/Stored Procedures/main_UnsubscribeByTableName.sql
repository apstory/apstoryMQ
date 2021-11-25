/*=====================Testing==================


*/
CREATE PROCEDURE [dbo].[main_UnsubscribeByTableName] 
     @ApplicationId int,
	 @TableName varchar(255)	 
AS
BEGIN
      declare @InitialTransCount int = @@TRANCOUNT     
      declare @TranName varchar(32) = OBJECT_NAME(@@PROCID)

      begin try
            if @InitialTransCount = 0 begin transaction @TranName
             
            delete dbo.[Subscription] where [dbo].[fun_GetTableName](ApplicationId, Client, Topic) = @TableName 
            declare @sql varchar(255)
            set @sql = 'drop table ' + @TableName + ''
            exec(@sql)            
            
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