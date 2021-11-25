using System;
using System.Data.SqlClient;

namespace Apstory.Apstorymq.Dal
{
    public class BaseRepository
    {
        private string _connectionString;
        public BaseRepository(string connectionString)
        {
            _connectionString = connectionString;
        }

        protected SqlConnection GetSqlConnection()
        {
            return new SqlConnection(_connectionString);
        }
    }
}
