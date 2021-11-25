/*=====================Testing==================

select dbo.[fun_CheckIfTableExists] (1, '[1].[testclient_testtopic]')

*/
CREATE FUNCTION [dbo].[fun_CheckIfTableExists]
(
	@ApplicationId int,
	@TableName varchar(128)
)
RETURNS bit
AS
BEGIN

	declare @DoesTableExists bit = 0
	declare @TableNameWithoutSchema varchar(128)

	set @TableNameWithoutSchema = right(@TableName, len(@TableName) - charindex('.', @TableName))
	set @TableNameWithoutSchema = replace(@TableNameWithoutSchema,'[','')
	set @TableNameWithoutSchema = replace(@TableNameWithoutSchema,']','')

	declare @SchemaName nvarchar(128)
	set @SchemaName = CAST(@ApplicationId as varchar)
		
	if exists(select 1 from INFORMATION_SCHEMA.TABLES where TABLE_SCHEMA = @SchemaName and TABLE_NAME = @TableNameWithoutSchema)
	begin
		set @DoesTableExists = 1
	end
	
	return @DoesTableExists
	
END