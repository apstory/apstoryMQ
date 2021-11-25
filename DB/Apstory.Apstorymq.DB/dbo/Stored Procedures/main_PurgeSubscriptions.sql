/*=====================Testing==================

*/
CREATE PROCEDURE [dbo].[main_PurgeSubscriptions] 
      @RetMsg varchar(50) output    
AS
BEGIN
      declare @InitialTransCount int = @@TRANCOUNT     
      declare @TranName varchar(32) = OBJECT_NAME(@@PROCID)

      begin try
            if @InitialTransCount = 0 begin transaction @TranName
 								
					select null as [TblDropped], Client, Topic, SubscriptionId, ApplicationId
					into #publishtmp
					from [Subscription]
										
					declare @subClient varchar(255)
					declare @subTopic varchar(255)
					declare @subId int	
					declare @appId int
					
					while exists(select * from #publishtmp where [TblDropped] is null)
					begin
						select distinct top 1 
						@subId = SubscriptionId, 
						@subClient = Client, 
						@subTopic = Topic,
						@appId = ApplicationId
						from #publishtmp 
						where [TblDropped] is null 
						
						declare @TableName varchar(255)
						set @TableName = [dbo].[fun_GetTableName](@appId,@subClient, @subTopic)
						
						declare @sql varchar(255)
						set @sql = 'drop table ' + @TableName + ''
						exec(@sql)			
												
						update #publishtmp set [TblDropped] = '1' where SubscriptionId = @subId				
					end
					
					truncate table Subscription
					truncate table PubSubMapping
					
					drop table #publishtmp
			
 
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