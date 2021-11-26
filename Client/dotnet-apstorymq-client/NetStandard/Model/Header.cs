namespace Apstory.Apstorymq.Client.NetStandard.Model
{
    public class Header
    {
        public string Client { get; set; }
        public string Topic { get; set; }
        public int? MessageId { get; set; }
        public string OriginalTopic { get; set; }
    }
}
