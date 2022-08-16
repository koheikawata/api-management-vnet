using Azure.Messaging.ServiceBus;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using Microsoft.Identity.Web;
using WeatherAPI.Authentication;
using WeatherAPI.Data;
using WeatherAPI.Interfaces;
using WeatherAPI.Services;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddMicrosoftIdentityWebApi(builder.Configuration.GetSection("AzureAd"));
builder.Services.AddDbContext<WeatherforecastContext>(options =>
{
    SqlAuthenticationProvider.SetProvider(SqlAuthenticationMethod.ActiveDirectoryDefault, new CustomAzureSQLAuthProvider());
    options.UseSqlServer(new SqlConnection(builder.Configuration.GetValue<string>("Sql:ConnectionString")));
});
builder.Services.AddScoped<ServiceBusClient>(sb => new ServiceBusClient(builder.Configuration.GetValue<string>("Servicebus:ConnectionString")));
builder.Services.AddScoped<ISqlRepository, SqlRepository>();
builder.Services.AddScoped<IMessageService, MessageService>();
builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(options =>
{
    options.SwaggerDoc("v1", new() { Title = "WeatherAPI", Version = "v1" });
});

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

app.Run();
