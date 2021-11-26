namespace Apstory.Apstorymq.Client.NetStandard.Model
{
    public class PagingParams
    {        
        public int PageNumber { get; set; } = 1;
        private const int maxPageSize = 1000;
        private int pageSize = 100;
        public int PageSize
        {
            get { return pageSize; }
            set { pageSize = (value < maxPageSize) ? value : maxPageSize;}
        }
    }
}
