using System.Collections.Generic;
using log4net;
using Microsoft.AspNetCore.Mvc;

namespace Apatory.Apstorymq.Api.Controllers
{
    [Produces("application/json")]
    [ApiVersion("1")]    
    public class TestController : Controller
    {
        private readonly static ILog _log = LogManager.GetLogger(typeof(TestController));

        public TestController()
        {
                 
        }

        // GET api/test
        [HttpGet]
        [Route("api/v{version:apiVersion}/test")]
        public IEnumerable<string> Get()
        {
            _log.Info("Get request for TestController");            
            return new string[] { "Hello World1", "Hello World2" };
        }
    }
}
