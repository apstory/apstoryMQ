using System;

namespace Apstory.Apstorymq.Common
{
    [Serializable]
    public class InvalidClientException : Exception
    {
        public InvalidClientException() { }
        public InvalidClientException(string message) : base(message) { }
        public InvalidClientException(string message, Exception inner) : base(message, inner) { }
        protected InvalidClientException(
          System.Runtime.Serialization.SerializationInfo info,
          System.Runtime.Serialization.StreamingContext context) : base(info, context) { }
    }
}
