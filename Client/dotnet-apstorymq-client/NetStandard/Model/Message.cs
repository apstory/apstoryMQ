using System.Collections.Generic;

namespace Apstory.Apstorymq.Client.NetStandard.Model
{
    public class Message
    {        
        public Header Header { get; set; }
        public List<Properties> Properties { get; set; }
        public object Body { get; set; }
    }        
}
