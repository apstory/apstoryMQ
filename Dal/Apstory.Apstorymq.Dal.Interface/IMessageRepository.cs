using Apstory.Apstorymq.Model;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Apstory.Apstorymq.Dal.Interface
{
    public interface IMessageRepository
    {
        Task<Messages> Get(string key, string client, string topic, PagingParams pagingPrams);
        Task<List<Message>> Post(List<Message> messages, string key, string client, string topic);
        Task<bool> Delete(string key, int messageId, string client, string topic);
        Task<List<Message>> Delete(List<Message> messages, string key, string client, string topic);        
    }
}
