CREATE PROCEDURE [dbo].[msg_GetAll]
	@ApplicationId	int,
	@Client			nvarchar(255),
	@Topic			nvarchar(255)   
AS

	declare @TableName varchar(255) = dbo.fun_GetTableName(@ApplicationId,@Client, @Topic)
   
	declare @sql nvarchar(MAX)								
			
	set @sql = 
	'
		select [MessageId], [Body], [OriginalTopic] 
		from ' + @TableName + ' order by [MessageId] asc
	'
			
	exec sp_executesql @sql

RETURN 0