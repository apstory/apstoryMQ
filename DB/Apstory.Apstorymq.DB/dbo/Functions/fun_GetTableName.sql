/*=====================Testing==================

*/
CREATE FUNCTION [dbo].[fun_GetTableName]
(
	@ApplicationId int,
	@Client varchar(255),
	@Topic varchar(255)
)
RETURNS varchar(255)
AS
BEGIN	
	return '[' + CAST(@ApplicationId as varchar) + '].[' + @Client + '_' + @Topic + ']'
END
