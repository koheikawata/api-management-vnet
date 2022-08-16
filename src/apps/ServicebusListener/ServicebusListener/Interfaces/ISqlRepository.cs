using ServicebusListener.Models;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace ServicebusListener.Interfaces
{
    public interface ISqlRepository
    {
        public Task<List<Weatherforecast>> GetWeatherforecastListAsync();
        public Task<Weatherforecast> AddWeatherforecastAsync(Weatherforecast weatherforecast);
    }
}
