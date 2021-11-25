using Apstory.Apstorymq.Dal.Interface;
using Apstory.Apstorymq.Dal.Model;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Threading.Tasks;

namespace Apstory.Apstorymq.Dal
{
    public class SubscriptionRepository : BaseRepository, ISubscriptionRepository
    {
        public SubscriptionRepository(string connectionString) : base(connectionString)
        {
        }

        public async Task<bool> Post(string key, string client, string topic)
        {            
            DynamicParameters parmsForCount = new DynamicParameters();
            DynamicParameters parms = new DynamicParameters();
            IEnumerable<DBMessage> dbMessages = new List<DBMessage>();
            string retMsg = string.Empty;
            int retVal = 0;

            parmsForCount.Add("Key", key);
            parmsForCount.Add("Client", client);
            parmsForCount.Add("Topic", topic);
            parmsForCount.Add("RetMsg", String.Empty, dbType: DbType.String, direction: ParameterDirection.Output);
            parmsForCount.Add("RetVal", dbType: DbType.Int32, direction: ParameterDirection.ReturnValue);

            parms.Add("Key", key);
            parms.Add("Client", client);
            parms.Add("Topic", topic);
            parms.Add("PageNumber", 1);
            parms.Add("PageSize", 1);
            parms.Add("RetMsg", String.Empty, dbType: DbType.String, direction: ParameterDirection.Output);
            parms.Add("RetVal", dbType: DbType.Int32, direction: ParameterDirection.ReturnValue);

            using (SqlConnection connection = GetSqlConnection())
            {
                dbMessages = await connection.QueryAsync<DBMessage>("[dbo].[sub_SubScribe]", parms, commandType: CommandType.StoredProcedure);                            
            }

            retMsg = parms.Get<string>("RetMsg");
            retVal = parms.Get<int>("RetVal");

            if (retVal == 1) { throw new Exception(retMsg); }
            return true;
        }

        public async Task<bool> Delete(string key, string client, string topic)
        {
            string retMsg = string.Empty;
            int retVal = 0;
            DynamicParameters parms = new DynamicParameters();
            parms.Add("Key", key);
            parms.Add("Client", client);
            parms.Add("Topic", topic);
            parms.Add("RetMsg", String.Empty, dbType: DbType.String, direction: ParameterDirection.Output);
            parms.Add("RetVal", dbType: DbType.Int32, direction: ParameterDirection.ReturnValue);

            using (SqlConnection connection = GetSqlConnection())
            {
                await connection.ExecuteAsync("[dbo].[sub_Unsubscribe]", parms, commandType: CommandType.StoredProcedure);
            }

            retMsg = parms.Get<string>("RetMsg");
            retVal = parms.Get<int>("RetVal");

            if (retVal == 1) { throw new Exception(retMsg); }
            return true;
        }        
    }
}
