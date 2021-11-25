
/*=====================Testing==================

declare @RetVal int
declare @RetMsg nvarchar(255)

exec @RetVal = [sub_GetMessageCount] '1234','testharnesssubscribe','publish.test', @RetMsg output

select @RetVal, @RetMsg

*/

CREATE PROCEDURE [dbo].[sub_GetMessageCount]
	@Key		nvarchar(255),
	@Client		nvarchar(255),
	@Topic		nvarchar(255),
	@RetMsg		nvarchar(255) output
AS           
BEGIN
	declare @RetVal	int = 1 
	declare @ApplicationId int

	exec @RetVal = app_GetKey @Key, @ApplicationId output, @RetMsg output
	if(@RetVal = 1)
	begin
		goto error_section
	end

    declare @TableName varchar(255) = dbo.fun_GetTableName(@ApplicationId, @Client, @Topic)	
   
	declare @sql nvarchar(MAX)							
			
	set @sql = 
	'
		select count(1)
		from ' + @TableName + '
	'
			
	exec sp_executesql
		@sql

	return 0
		
	error_section:                                 
        if (@RetMsg = null)
		set @Retmsg = ERROR_MESSAGE()
        return 1

END