using System.Threading.Tasks;

namespace Apstory.Apstorymq.Dal.Interface
{
    public interface ISubscriptionRepository
    {
        Task<bool> Post(string key, string client, string topic);
        Task<bool> Delete(string key, string client, string topic);
    }
}
