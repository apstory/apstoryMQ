/*=====================Testing==================

*/
CREATE PROCEDURE [dbo].[main_GetQueueDepth]
		@ApplicationId	int,
		@Client			varchar(255),
		@Topic			varchar(255)		
AS
BEGIN                  
			
		declare @TableName varchar(255)
		set @TableName = [dbo].[fun_GetTableName](@ApplicationId, @Client, @Topic)						
			
		declare @sql varchar(255)            
        set @sql = 'select count(*) from ' + @TableName + ''
		exec(@sql)															
                                   
END