using Apstory.Apstorymq.Api.Extensions;
using Apstory.Apstorymq.Domain.Interface;
using Apstory.Apstorymq.Model;
using log4net;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Apstory.Apstorymq.Api.Controllers
{
    [Produces("application/json")]
    [ApiVersion("1")]    
    public class MessageController : Controller, IMessageService
    {
        private readonly IMessageService _service;
        private readonly static ILog _log = LogManager.GetLogger(typeof(MessageController));

        public MessageController(IMessageService service)
        {
            _service = service;
        }

        /// <summary>
        /// Get messages from a topic
        /// </summary>
        /// <param name="key">API key</param>
        /// <param name="client">Subscribing client (unique id for the service or app that is subscribing)</param>
        /// <param name="topic">Subscribing topic</param>
        /// <param name="pagingParams">Set the page number and page size of messages to return</param>
        [HttpGet]
        [Route("api/v{version:apiVersion}/message")]        
        public async Task<Messages> Get(string key, string client, string topic, PagingParams pagingParams)
        {                                  
            return await _service.Get(key, client, topic, pagingParams);
        }

        /// <summary>
        /// Publish messages to a topic
        /// </summary>
        /// <param name="messages">Payload</param>
        /// <param name="key">API key</param>
        /// <param name="client">Publishing client (unique id for the service or app that is publishing)</param>
        /// <param name="topic">Publishing topic</param>
        [HttpPost]
        [Route("api/v{version:apiVersion}/message")]        
        public async Task<List<Message>> Post([FromBody]List<Message> messages, string key, string client, string topic)
        {                        
            return await _service.Post(messages, key, client, topic);
        }

        /// <summary>
        /// Commit message
        /// </summary>
        /// <param name="key">API key</param>
        /// <param name="messageId">MessageId to commit (pop off the queue)</param>        
        /// <param name="client">Subscribing client (unique id for the service or app that is subscribing)</param>
        /// <param name="topic">Subscribing topic</param>  
        [HttpDelete]
        [Route("api/v{version:apiVersion}/message/{messageId:int}")]        
        public async Task<bool> Delete(string key, int messageId, string client, string topic)
        {            
            return await _service.Delete(key, messageId, client, topic);
        }

        /// <summary>
        /// Commit message list
        /// </summary>
        /// <param name="messages">Message list to commit (pop off the queue)</param>  
        /// <param name="key">API key</param>              
        /// <param name="client">Subscribing client (unique id for the service or app that is subscribing)</param>
        /// <param name="topic">Subscribing topic</param>
        [HttpDelete]
        [Route("api/v{version:apiVersion}/message")]        
        public async Task<List<Message>> Delete([FromBody]List<Message> messages, string key, string client, string topic)
        {            
            return await _service.Delete(messages, key, client, topic);
        }
    }
}