/*=====================Testing==================

*/
CREATE FUNCTION [dbo].[fun_ConvertTopicWildcard]
(
	@Topic varchar(255)
)
RETURNS varchar(255)
AS
BEGIN
	
	set @Topic = REPLACE(@Topic,'*','%')
	set @Topic = REPLACE(@Topic,'#','%')	
    
	RETURN @Topic

END
