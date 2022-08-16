using Microsoft.Azure.Functions.Extensions.DependencyInjection;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using ServicebusListener.Authentication;
using ServicebusListener.Interfaces;
using ServicebusListener.Repositories;

[assembly: FunctionsStartup(typeof(ServicebusListener.Startup))]
namespace ServicebusListener
{
    public class Startup : FunctionsStartup
    {
        public override void Configure(IFunctionsHostBuilder builder)
        {
            builder.Services.AddDbContext<WeatherforecastContext>(options =>
            {
                SqlAuthenticationProvider.SetProvider(SqlAuthenticationMethod.ActiveDirectoryDefault, new CustomAzureSQLAuthProvider());
                options.UseSqlServer(new SqlConnection(builder.GetContext().Configuration.GetValue<string>("SqlConnectionString")));
            });
            builder.Services.AddScoped<ISqlRepository, SqlRepository>();
        }
    }
}
