using System.Threading.Tasks;
using Apstory.Apstorymq.Domain.Interface;
using log4net;
using Microsoft.AspNetCore.Mvc;

namespace Apstory.Apstorymq.Api.Controllers
{
    [Produces("application/json")]
    [ApiVersion("1")]
    public class SubscriptionController : ControllerBase, ISubscriptionService
    {
        private readonly ISubscriptionService _service;
        private readonly static ILog _log = LogManager.GetLogger(typeof(MessageController));

        public SubscriptionController(ISubscriptionService service)
        {
            _service = service;
        }

        /// <summary>
        /// Unsubscribe from a topic (queue will be deleted)
        /// </summary>
        /// <param name="key">API key</param>              
        /// <param name="client">Subscribing client (unique id for the service or app that is subscribing)</param>
        /// <param name="topic">Subscribing topic</param>
        [HttpDelete]
        [Route("api/v{version:apiVersion}/subscriptions")]
        public async Task<bool> Delete(string key, string client, string topic)
        {
            return await _service.Delete(key, client, topic);
        }

        /// <summary>
        /// Create a topic subscription
        /// </summary>
        /// <param name="key">API key</param>
        /// <param name="client">Subscribing client (unique id for the service or app that will be subscribing)</param>
        /// <param name="topic">Subscribing topic</param>
        [HttpPost]
        [Route("api/v{version:apiVersion}/subscriptions")]
        public async Task<bool> Post(string key, string client, string topic)
        {
            return await _service.Post(key, client, topic);
        }
    }
}