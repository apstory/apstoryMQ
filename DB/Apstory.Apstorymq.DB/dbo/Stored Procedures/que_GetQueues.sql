/*=====================Testing==================
exec [que_GetQueues] 1
*/
CREATE PROCEDURE [dbo].[que_GetQueues]
		@ApplicationId	int		
AS
BEGIN                  
										
		declare @SchemaName nvarchar(128)
		set @SchemaName = CAST(@ApplicationId as nvarchar)		
		select queues.TABLE_NAME,i.rowcnt from INFORMATION_SCHEMA.TABLES queues
		inner join sysobjects AS o on o.name = queues.TABLE_NAME
		inner join sysindexes AS i ON i.id = o.id
		where i.indid < 2  AND OBJECTPROPERTY(o.id, 'IsMSShipped') = 0
		and queues.TABLE_SCHEMA = @SchemaName
		order by i.rowcnt desc

END