/*=====================Testing==================

declare @RetVal int
declare @RetMsg varchar(50)
declare @ApplicationId int

exec @RetVal = [app_GetKey] '1234', @ApplicationId output, @RetMsg output

select @RetVal, @ApplicationId, @RetMsg

*/

CREATE PROCEDURE [dbo].[app_GetKey]
	@Key			nvarchar(255),
	@ApplicationId	int output,
	@RetMsg			nvarchar(500) output
AS	
BEGIN  		

	select top 1 @ApplicationId = [ApplicationId] from [Application] with(nolock) where [Key] = @Key and IsActive = 1

	if(@ApplicationId is null)
	begin
		set @RetMsg = 'Invalid key'
		goto error_section
	end

	return 0

	error_section:                                 
        if (@RetMsg = null)
		set @Retmsg = ERROR_MESSAGE()
        return 1

END