using Apstory.Apstorymq.Api.Extensions;
using Apstory.Apstorymq.Dal;
using Apstory.Apstorymq.Dal.Interface;
using Apstory.Apstorymq.Domain;
using Apstory.Apstorymq.Domain.Interface;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http.Features;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Microsoft.OpenApi.Models;
using System;
using System.IO;
using System.Reflection;

namespace Apstory.Apstorymq.Api
{
    public class Startup
    {
        public Startup(IWebHostEnvironment env)
        {
            var builder = new ConfigurationBuilder()
                .SetBasePath(env.ContentRootPath)
                .AddJsonFile("appsettings.json", optional: false, reloadOnChange: true)
                .AddJsonFile($"appsettings.{env.EnvironmentName}.json", optional: true)
                .AddEnvironmentVariables();
            builder.AddEnvironmentVariables();
            Configuration = builder.Build();            
        }

        public IConfigurationRoot Configuration { get; }        

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            services.Configure<IISServerOptions>(options =>
            {
                options.MaxRequestBodySize = int.MaxValue;
            });            
            var connectionString = Configuration.GetConnectionString("ApstorymqDatabase");                  

            services.AddCors(options =>
            {
                // this defines a CORS policy called "default"
                options.AddPolicy("default", policy =>
                {
                    policy.AllowAnyOrigin()
                          .AllowAnyHeader()
                          .AllowAnyMethod();
                });
            });

            services.AddMvc();
            services.AddApplicationInsightsTelemetry();
            services.AddApiVersioning();            
            services.AddResponseCompression(options =>
            {                
                options.EnableForHttps = true;
            });            

            services.AddSwaggerGen(c =>
            {
                c.SwaggerDoc("v1", new OpenApiInfo {
                    Title = "apstorymq API",
                    Version = "v1",
                    Description = "apstorymq Restful API",
                    Contact = new OpenApiContact
                    {
                        Name = "Apstory",
                        Email = "development@apstory.co.za",
                        Url = new Uri("https://www.apstory.co.za")
                    },
                });
                // Set the comments path for the Swagger JSON and UI.
                var xmlFile = $"{Assembly.GetExecutingAssembly().GetName().Name}.xml";
                var xmlPath = Path.Combine(AppContext.BaseDirectory, xmlFile);
                c.IncludeXmlComments(xmlPath);
            });

            services.AddTransient<IMessageRepository>((arg) => { return new MessageRepository(connectionString); });            
            services.AddTransient<IMessageService, MessageService>();
            services.AddTransient<ISubscriptionRepository>((arg) => { return new SubscriptionRepository(connectionString); });
            services.AddTransient<ISubscriptionService, SubscriptionService>();

            services.AddControllers().AddNewtonsoftJson();
        }        

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, ILoggerFactory loggerFactory)
        {
            loggerFactory.AddLog4Net();
            app.UseMiddleware<Middlewares.ErrorHandlerMiddleware>();
            app.UseStaticFiles();
            app.UseSwagger();
            app.UseSwaggerUI(c =>
            {
                c.SwaggerEndpoint("./swagger/v1/swagger.json", "apstorymq API V1");
                c.RoutePrefix = string.Empty;
            });
            app.UseRouting();
            app.UseCors("default");
            app.UseResponseCompression();            
            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
            });                                                          
        }
    }
}
