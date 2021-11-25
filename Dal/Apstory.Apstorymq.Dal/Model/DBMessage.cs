using System;

namespace Apstory.Apstorymq.Dal.Model
{
    public class DBMessage
    {
        public int MessageId { get; set; }
        public Byte[] Body { get; set; }
        public string Properties { get; set; }
        public string OriginalTopic { get; set; }
    }
}
