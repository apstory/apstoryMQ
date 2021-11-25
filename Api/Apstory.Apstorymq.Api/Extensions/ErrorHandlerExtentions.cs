using Apstory.Apstorymq.Api.Middlewares;
using Microsoft.AspNetCore.Builder;

namespace Apstory.Apstorymq.Api.Extensions
{
    public static class ErrorHandlerExtentions
    {
        public static IApplicationBuilder UseErrorHandlerMiddleware(this IApplicationBuilder builder)
        {
            return builder.UseMiddleware<ErrorHandlerMiddleware>();
        }
    }
}
