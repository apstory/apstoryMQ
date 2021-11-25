
/*=====================Testing==================

declare @RetMsg varchar(255)
exec [sub_CreateMessageTable] 1,'testclient','testtopic', @RetMsg output

select @RetMsg

*/

CREATE PROCEDURE [dbo].[sub_CreateMessageTable]
	@ApplicationId	int,
	@Client			varchar(255),
	@Topic			varchar(255), 	
    @RetMsg			varchar(255) output    
AS
BEGIN
      declare @InitialTransCount int = @@TRANCOUNT     
      declare @TranName varchar(32) = OBJECT_NAME(@@PROCID)

      begin try
            if @InitialTransCount = 0 begin transaction @TranName            

			declare @TableName varchar(255) = dbo.fun_GetTableName(@ApplicationId,@Client, @Topic)
			
			if ((select dbo.fun_CheckIfTableExists (@ApplicationId,@TableName)) = 0)
			begin
							
				declare @SqlSchema nvarchar(MAX)
				declare @SchemaName nvarchar(128)

				set @SchemaName = CAST(@ApplicationId as varchar(10))

				print @SchemaName
				
				set @SqlSchema = 
				'		
					IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = ''' + @SchemaName + ''')
					BEGIN								
						EXEC(''CREATE SCHEMA [' + @SchemaName + ']'')
					END
				'

				print @SqlSchema
	            
	            exec sp_executesql @SqlSchema

				declare @Sql nvarchar(MAX)
				
				set @Sql = 
				'										
					CREATE TABLE ' + @TableName + '(
						[MessageId] INT IDENTITY (1, 1) NOT NULL,
						[Body] [varbinary] (MAX) NOT NULL,
						[Properties] [nvarchar] (MAX),
						[OriginalTopic] [nvarchar] (255) NOT NULL,					
						[CreateDT] [datetime] NOT NULL DEFAULT (GETDATE()),
						PRIMARY KEY CLUSTERED ([MessageId] ASC)
					)					
				'
	            
	            exec sp_executesql @Sql				
				
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