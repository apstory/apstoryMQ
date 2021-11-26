using System.Collections.Generic;

namespace Apstory.Apstorymq.Client.NetStandard.Model
{
    public class Messages
    {
        public Paging Paging { get; set; }
        public List<Message> Message { get; set; }
    }
}
