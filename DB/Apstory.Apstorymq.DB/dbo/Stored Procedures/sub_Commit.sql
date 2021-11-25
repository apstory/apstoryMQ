/*=====================Testing==================


*/
CREATE PROCEDURE [dbo].[sub_Commit]
	@Key			nvarchar(255),
	@Client			nvarchar(255),
	@Topic			nvarchar(255),
	@MessageId	    INT,
    @RetMsg			nvarchar(255) output
AS
BEGIN
      declare @InitialTransCount int = @@TRANCOUNT     
      declare @TranName varchar(32) = OBJECT_NAME(@@PROCID)

      begin try
            if @InitialTransCount = 0 begin transaction @TranName

			declare @RetVal	int = 1  
			declare @ApplicationId int
			
			exec @RetVal = app_GetKey @Key, @ApplicationId output, @RetMsg output
			if(@RetVal = 1)
			begin
				goto error_section
			end
            
			declare @TableName varchar(255) = dbo.fun_GetTableName(@ApplicationId,@Client, @Topic)
			      			
			declare @sql nvarchar(MAX)				
			set @sql = 'delete ' + @TableName + ' where MessageId = @MessageId'					
						
			exec sp_executesql
				@sql,
				N'@MessageId int',
				@MessageId
            
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