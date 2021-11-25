using Apstory.Apstorymq.Common;
using System.Text.RegularExpressions;

namespace Apstory.Apstorymq.Api.Extensions
{
    public static class ValidationExtentions
    {
        public static void IsValidClient(this string client)
        {
            var regexItem = new Regex("^[a-zA-Z0-9]*$");
            if (!regexItem.IsMatch(client))
                throw new InvalidTopicException("Invalid topic, special characters are not allowed for publish");
        }

        public static void IsValidTopic(this string topic)
        {
            var regexItem = new Regex("^[a-zA-Z0-9._]*$");
            if (!regexItem.IsMatch(topic))
                throw new InvalidClientException("Invalid client, special characters are not allowed");
        }
    }
}
