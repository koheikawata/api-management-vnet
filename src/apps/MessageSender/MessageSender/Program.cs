using Azure.Messaging.ServiceBus;
using MessageSender.Models;
using Microsoft.Extensions.Configuration;
using System.Text.Json;

namespace MessageSender;

public class Program
{
    private static string connectionString = Environment.GetEnvironmentVariable("SERVICE_BUS_CONNECTION_STRING") ?? string.Empty;

    public static async Task Main(string[] args)
    {
        IConfiguration config = new ConfigurationBuilder()
            .AddJsonFile("appsettings.json", optional: true, reloadOnChange: true)
            .AddJsonFile("appsettings.Development.json", optional: true, reloadOnChange: true)
            .AddEnvironmentVariables()
            .Build();

        if (connectionString == string.Empty)
        {
            connectionString = config.GetValue<string>("Servicebus:ConnectionString");
        }
        string topicName = config.GetValue<string>("Servicebus:TopicName");
        const int numOfMessages = 3;

        ServiceBusClient client = new (connectionString);
        ServiceBusSender sender = client.CreateSender(topicName);

        using ServiceBusMessageBatch messageBatch = await sender.CreateMessageBatchAsync();
        string messageBody = JsonSerializer.Serialize(
            new Weatherforecast()
            {
                Id = Guid.NewGuid().ToString(),
                Country = "Germany",
                City = "Berlin",
                TemperatureC = 20,
                Summary = "Sunny",
            },
            new JsonSerializerOptions() { WriteIndented = true }
        );

        if (!messageBatch.TryAddMessage(new ServiceBusMessage(messageBody)))
        {
            throw new Exception($"The message is too large to fit in the batch.");
        }

        try
        {
            await sender.SendMessagesAsync(messageBatch);
            Console.WriteLine($"A batch of {numOfMessages} messages has been published to the topic.");
        }
        catch (Exception ex)
        {
            Console.WriteLine(ex.Message);
        }
        finally
        {
            await sender.DisposeAsync();
            await client.DisposeAsync();
        }

        Console.WriteLine($"Successfully sent message: \n{messageBody}");
    }
}
