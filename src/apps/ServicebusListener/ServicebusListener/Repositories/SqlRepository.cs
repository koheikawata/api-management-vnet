using Microsoft.EntityFrameworkCore;
using ServicebusListener.Interfaces;
using ServicebusListener.Models;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace ServicebusListener.Repositories
{
    public class SqlRepository : ISqlRepository
    {
        private readonly WeatherforecastContext weatherforecastContext;

        public SqlRepository(WeatherforecastContext weatherforecastContext)
        {
            this.weatherforecastContext = weatherforecastContext;
        }

        public async Task<List<Weatherforecast>> GetWeatherforecastListAsync()
        {
            return await this.weatherforecastContext.Weatherforecasts.ToListAsync().ConfigureAwait(false);
        }

        public async Task<Weatherforecast> AddWeatherforecastAsync(Weatherforecast weatherforecast)
        {
            await this.weatherforecastContext.Weatherforecasts.AddAsync(weatherforecast).ConfigureAwait(false);
            await this.weatherforecastContext.SaveChangesAsync().ConfigureAwait(false);

            return weatherforecast;
        }
    }
}
