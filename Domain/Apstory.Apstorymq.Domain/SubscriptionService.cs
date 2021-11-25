using Apstory.Apstorymq.Dal.Interface;
using Apstory.Apstorymq.Domain.Extentions;
using Apstory.Apstorymq.Domain.Interface;
using System.Threading.Tasks;

namespace Apstory.Apstorymq.Domain
{
    public class SubscriptionService : ISubscriptionService
    {
        private ISubscriptionRepository _repo;

        public SubscriptionService(ISubscriptionRepository repo)
        {
            _repo = repo;
        }

        public async Task<bool> Delete(string key, string client, string topic)
        {
            client.IsValidClient();
            return await _repo.Delete(key, client, topic);
        }

        public async Task<bool> Post(string key, string client, string topic)
        {
            topic.IsValidTopic();
            client.IsValidClient();
            return await _repo.Post(key, client, topic);
        }
    }
}
