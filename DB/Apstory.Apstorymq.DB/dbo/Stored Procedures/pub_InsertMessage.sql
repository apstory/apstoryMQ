/*=====================Testing==================

declare @RetVal int
declare @RetMsg varchar(255)

declare @body varbinary(MAX)

set @body = CAST('Test' as varbinary)

exec @RetVal = pub_InsertMessage 1,'testclient' ,'testtopic', null, @body, @RetMsg output

select @RetVal, @RetMsg

*/
CREATE PROCEDURE [dbo].[pub_InsertMessage] 
	@ApplicationId		int,
	@Client				varchar(255),
	@SubscriptionTopic	varchar(255),
	@OriginalTopic		varchar(255),
	@Body				VARBINARY(MAX),	
	@Properties			NVARCHAR(MAX),
    @RetMsg				varchar(255) output    
AS
BEGIN
      declare @InitialTransCount int = @@TRANCOUNT     
      declare @TranName varchar(32) = OBJECT_NAME(@@PROCID)

      begin try
            if @InitialTransCount = 0 begin transaction @TranName
     
			declare @TableName varchar(255) = dbo.fun_GetTableName(@ApplicationId,@Client, @SubscriptionTopic)			
						
			if ((select dbo.fun_CheckIfTableExists (@ApplicationId,@TableName)) = 1)
			begin

				declare @sql nvarchar(MAX)
				
				set @sql = '
					insert into ' + @TableName + ' (Body, OriginalTopic, Properties) 
					values (@Body, @OriginalTopic, @Properties)'
						
				exec sp_executesql
					@sql,					
					N'@Body varbinary (MAX), @OriginalTopic nvarchar (255), @Properties nvarchar (MAX)',					
					@Body,					
					@OriginalTopic,
					@Properties
				
			end
            
            --Exit Successful
            if @InitialTransCount = 0 commit transaction @TranName
            set @RetMsg = 'Successful'
            return 0
            
            --Error Section
            error_section:
                  if @InitialTransCount = 0 rollback transaction @TranName                  
                  if (@RetMsg = null)
					set @Retmsg = ERROR_MESSAGE()
                  return 1
      end try
      begin catch
            if @InitialTransCount = 0 rollback transaction @TranName
            set @RetMsg = ERROR_MESSAGE()                        
            return 1
      end catch
END