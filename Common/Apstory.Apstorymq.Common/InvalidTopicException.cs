using System;

namespace Apstory.Apstorymq.Common
{
    [Serializable]
    public class InvalidTopicException : Exception
    {
        public InvalidTopicException() { }
        public InvalidTopicException(string message) : base(message) { }
        public InvalidTopicException(string message, Exception inner) : base(message, inner) { }
        protected InvalidTopicException(
          System.Runtime.Serialization.SerializationInfo info,
          System.Runtime.Serialization.StreamingContext context) : base(info, context) { }
    }
}
