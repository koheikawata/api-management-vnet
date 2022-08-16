using Azure.Messaging.ServiceBus;
using System.Text.Json;
using WeatherAPI.Interfaces;

namespace WeatherAPI.Services;

public class MessageService : IMessageService
{
    private readonly IConfiguration configuration;
    private readonly ServiceBusClient serviceBusClient;

    public MessageService(IConfiguration configuration, ServiceBusClient serviceBusClient)
    {
        this.configuration = configuration;
        this.serviceBusClient = serviceBusClient;
    }

    public async Task SendMessageAsync(Weatherforecast weatherforecast)
    {
        ServiceBusSender serviceBusSender = this.serviceBusClient.CreateSender(configuration.GetValue<string>("Servicebus:TopicName"));
        using ServiceBusMessageBatch messageBatch = await serviceBusSender.CreateMessageBatchAsync().ConfigureAwait(false);
        string messageBody = JsonSerializer.Serialize(weatherforecast, new JsonSerializerOptions() { WriteIndented = true });

        if (!messageBatch.TryAddMessage(new ServiceBusMessage(messageBody)))
        {
            throw new Exception($"The message is too large to fit in the batch.");
        }

        try
        {
            await serviceBusSender.SendMessagesAsync(messageBatch).ConfigureAwait(false);
        }
        catch (Exception)
        {
            throw;
        }
    }
}
