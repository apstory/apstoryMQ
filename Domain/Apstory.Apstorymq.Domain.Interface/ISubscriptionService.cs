using System.Threading.Tasks;

namespace Apstory.Apstorymq.Domain.Interface
{
    public interface ISubscriptionService
    {
        Task<bool> Post(string key, string client, string topic);
        Task<bool> Delete(string key, string client, string topic);
    }
}
