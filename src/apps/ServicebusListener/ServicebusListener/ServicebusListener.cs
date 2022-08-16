using System;
using System.Threading.Tasks;
using Microsoft.Azure.WebJobs;
using Microsoft.Extensions.Logging;
using ServicebusListener.Interfaces;
using ServicebusListener.Models;

namespace ServicebusListener
{
    public class ServicebusListener
    {
        private readonly ISqlRepository sqlRepository;

        public ServicebusListener(ISqlRepository sqlRepository)
        {
            this.sqlRepository = sqlRepository;
        }

        [FunctionName("ServicebusListener")]
        public async Task Run([ServiceBusTrigger("%ServiceBusTopic%", "%ServiceBusSubscription%", Connection = "ServiceBusConnectionString")] Weatherforecast weatherforecast, string messageId, ILogger logger)
        {
            if (weatherforecast == null)
            {
                logger.LogInformation($"message {messageId} has invalid status");
                throw new ArgumentNullException();
            }

            try
            {
                Weatherforecast addedWeatherforecast = await this.sqlRepository.AddWeatherforecastAsync(weatherforecast).ConfigureAwait(false);
                logger.LogInformation($"Successfully inserted the data of {messageId} to the database");
            }
            catch (Exception ex)
            {
                logger.LogError($"Exception message:{ex.Message}");
            }
        }
    }
}
