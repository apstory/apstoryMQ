/*=====================Testing==================
exec [sub_GetMessage] 'TestHarnessSubscribe','Publish.Test',1,100
*/

CREATE PROCEDURE [dbo].[sub_GetMessage] 
	@ApplicationId	int,
	@Client			varchar(255),
	@Topic			varchar(255),
	@PageNumber		INT,
	@PageSize		INT
AS
BEGIN            
            
    declare @TableName varchar(255) = dbo.fun_GetTableName(@ApplicationId,@Client, @Topic)
   
	declare @sql nvarchar(MAX)							
			
	set @sql = 
	'
		select [MessageId], [Body], [Properties], [OriginalTopic] 
		from ' + @TableName + ' order by [MessageId] asc
		offset (@PageNumber - 1) * @PageSize rows fetch next @PageSize ROWS ONLY
	'
			
	exec sp_executesql 	
		@sql,					
		N'@PageNumber int, @PageSize int',					
		@PageNumber,					
		@PageSize

END