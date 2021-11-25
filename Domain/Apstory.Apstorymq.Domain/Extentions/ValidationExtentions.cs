using Apstory.Apstorymq.Common;
using System.Text.RegularExpressions;

namespace Apstory.Apstorymq.Domain.Extentions
{
    public static class ValidationExtentions
    {
        public static void IsValidClient(this string client)
        {
            if (client != null)
            {
                if (client.Length > 28)
                    throw new InvalidClientException("Invalid client, length must not be greater than 28 characters.");
                var regexItem = new Regex("^[a-zA-Z0-9]*$");
                if (!regexItem.IsMatch(client))
                    throw new InvalidClientException("Invalid client, special characters are not allowed.");
            }
            else
            {
                throw new InvalidClientException("Invalid client, value cannot be null");
            }
        }

        public static void IsValidTopic(this string topic)
        {
            if (topic != null)
            {
                if (topic.Length > 100)
                    throw new InvalidTopicException("Invalid topic, length must not be greater than 100 characters.");
                var regexItem = new Regex("^[a-zA-Z0-9._]*$");
                if (!regexItem.IsMatch(topic))
                    throw new InvalidTopicException("Invalid topic, special characters other than (.) and (_) are not allowed.");
            }
            else
            {
                throw new InvalidTopicException("Invalid topic, value cannot be null.");
            }
        }
    }
}
