using Apstory.Apstorymq.Dal.Interface;
using Apstory.Apstorymq.Domain.Extentions;
using Apstory.Apstorymq.Domain.Interface;
using Apstory.Apstorymq.Model;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Apstory.Apstorymq.Domain
{
    public class MessageService : IMessageService
    {
        private IMessageRepository _repo;

        public MessageService(IMessageRepository repo)
        {
            _repo = repo;
        }        

        public async Task<Messages> Get(string key, string client, string topic, PagingParams pagingParams)
        {
            client.IsValidClient();
            return await _repo.Get(key, client, topic, pagingParams);
        }

        public async Task<List<Message>> Post(List<Message> messages, string key, string client, string topic)
        {
            topic.IsValidTopic();
            client.IsValidClient();
            return await _repo.Post(messages, key, client, topic);
        }

        public async Task<bool> Delete(string key, int messageId, string client, string topic)
        {
            client.IsValidClient();
            return await _repo.Delete(key, messageId, client, topic);
        }

        public async Task<List<Message>> Delete(List<Message> messages, string key, string client, string topic)
        {
            client.IsValidClient();
            return await _repo.Delete(messages, key, client, topic);
        }        
    }
}
