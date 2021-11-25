using Apstory.Apstorymq.Dal.Extensions;
using Apstory.Apstorymq.Dal.Interface;
using Apstory.Apstorymq.Dal.Model;
using Apstory.Apstorymq.Model;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Threading.Tasks;

namespace Apstory.Apstorymq.Dal
{
    public class MessageRepository : BaseRepository, IMessageRepository
    {
        public MessageRepository(string connectionString) : base(connectionString)
        {
        }

        public async Task<Messages> Get(string key, string client, string topic, PagingParams pagingParams)
        {
            IEnumerable<DBMessage> dbMessages = new List<DBMessage>();
            DynamicParameters parmsForCount = new DynamicParameters();
            DynamicParameters parms = new DynamicParameters();
            int totalRecords = 0;
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
            parms.Add("PageNumber", pagingParams.PageNumber);
            parms.Add("PageSize", pagingParams.PageSize);
            parms.Add("RetMsg", String.Empty, dbType: DbType.String, direction: ParameterDirection.Output);
            parms.Add("RetVal", dbType: DbType.Int32, direction: ParameterDirection.ReturnValue);

            using (SqlConnection connection = GetSqlConnection())
            {                
                dbMessages = await connection.QueryAsync<DBMessage>("[dbo].[sub_SubScribe]", parms, commandType: CommandType.StoredProcedure);
                retMsg = parms.Get<string>("RetMsg");
                retVal = parms.Get<int>("RetVal");

                if (retVal == 1) { throw new Exception(retMsg); }

                totalRecords = await connection.QueryFirstAsync<int>("[dbo].[sub_GetMessageCount]", parmsForCount, commandType: CommandType.StoredProcedure);
                retMsg = parmsForCount.Get<string>("RetMsg");
                retVal = parmsForCount.Get<int>("RetVal");

                if (retVal == 1) { throw new Exception(retMsg); }
            }

            if (dbMessages.Count() > 0)
            {
                var messages = dbMessages.Select(a => new Message
                {
                    Header = new Header
                    {
                        Client = client,
                        Topic = topic,
                        MessageId = a.MessageId,
                        OriginalTopic = a.OriginalTopic                        
                    },
                    Properties = a.Properties?.JsonStringToObject<List<Properties>>(),
                    Body = a.Body.ByteArrayToObject()
                }).ToList();                

                return new Messages
                {
                    Paging = new Paging
                    {
                        PageNumber = pagingParams.PageNumber,
                        PageSize = pagingParams.PageSize,
                        TotalRecords = totalRecords
                    },
                    Message = messages
                };
            }
            else
            {
                return new Messages
                {
                    Paging = new Paging
                    {
                        PageNumber = pagingParams.PageNumber,
                        PageSize = pagingParams.PageSize,                        
                        TotalRecords = 0
                    },
                    Message = new List<Message>()
                };
            }
        }

        public async Task<List<Message>> Post(List<Message> messages, string key, string client, string topic)
        {
            DynamicParameters parms = new DynamicParameters();
            List<Message> retMessages = new List<Message>();
            string retMsg = string.Empty;
            int retVal = 0;

            using (SqlConnection connection = GetSqlConnection())
            {
                foreach (var message in messages)
                {                    
                    parms.Add("Key", key);
                    parms.Add("Client", client);
                    parms.Add("Topic", topic);
                    parms.Add("Body", message.Body.ObjectToByteArray());
                    parms.Add("Properties", message.Properties.ObjectToJsonString());
                    parms.Add("RetMsg", String.Empty, dbType: DbType.String, direction: ParameterDirection.Output);
                    parms.Add("RetVal", dbType: DbType.Int32, direction: ParameterDirection.ReturnValue);

                    await connection.ExecuteAsync("[dbo].[pub_PublishMessage]", parms, commandType: CommandType.StoredProcedure);
                    retMsg = parms.Get<string>("RetMsg");
                    retVal = parms.Get<int>("RetVal");

                    if (retVal == 1) { throw new Exception(retMsg); }

                    retMessages.Add(new Message
                    {
                        Header = new Header
                        {
                            Client = client,
                            Topic = topic
                        },
                        Body = message.Body,
                        Properties = message.Properties
                    });
                }
            }
            return retMessages;
        }

        public async Task<bool> Delete(string key, int messageId, string client, string topic)
        {
            string retMsg = string.Empty;
            int retVal = 0;
            DynamicParameters parms = new DynamicParameters();
            parms.Add("Key", key);
            parms.Add("Client", client);
            parms.Add("Topic", topic);
            parms.Add("MessageId", messageId);
            parms.Add("RetMsg", String.Empty, dbType: DbType.String, direction: ParameterDirection.Output);
            parms.Add("RetVal", dbType: DbType.Int32, direction: ParameterDirection.ReturnValue);

            using (SqlConnection connection = GetSqlConnection())
            {
                await connection.ExecuteAsync("[dbo].[sub_Commit]", parms, commandType: CommandType.StoredProcedure);
            }

            retMsg = parms.Get<string>("RetMsg");
            retVal = parms.Get<int>("RetVal");

            if (retVal == 1) { throw new Exception(retMsg); }
            return true;
        }

        public async Task<List<Message>> Delete(List<Message> messages, string key, string client, string topic)
        {
            var retMessages = new List<Message>();
            foreach (var message in messages)
            {
                string retMsg = string.Empty;
                int retVal = 0;
                DynamicParameters parms = new DynamicParameters();
                parms.Add("Key", key);
                parms.Add("Client", client);
                parms.Add("Topic", topic);
                parms.Add("MessageId", message.Header.MessageId);
                parms.Add("RetMsg", String.Empty, dbType: DbType.String, direction: ParameterDirection.Output);
                parms.Add("RetVal", dbType: DbType.Int32, direction: ParameterDirection.ReturnValue);

                using (SqlConnection connection = GetSqlConnection())
                {
                    await connection.ExecuteAsync("[dbo].[sub_Commit]", parms, commandType: CommandType.StoredProcedure);
                }

                retMsg = parms.Get<string>("RetMsg");
                retVal = parms.Get<int>("RetVal");                

                if (retVal == 0)
                {
                    retMessages.Add(message);
                }
            }            
            return retMessages;
        }

    }
}
