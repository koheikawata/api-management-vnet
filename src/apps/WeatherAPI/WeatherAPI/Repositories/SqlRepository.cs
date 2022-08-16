using Microsoft.EntityFrameworkCore;
using WeatherAPI.Interfaces;

namespace WeatherAPI.Data;

public class SqlRepository : ISqlRepository
{
    private readonly WeatherforecastContext weatherforecastContext;

    public SqlRepository(WeatherforecastContext weatherforecastContext)
    {
        this.weatherforecastContext = weatherforecastContext;
    }

    public IQueryable<Weatherforecast> GetWeatherforecasts(string id)
    {
        return this.weatherforecastContext.Weatherforecasts.Where(x => x.Id == id);
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

    public async Task DeleteWeatherforecastAsync(Weatherforecast weatherforecast)
    {
        this.weatherforecastContext.Weatherforecasts.Remove(weatherforecast);
        await this.weatherforecastContext.SaveChangesAsync().ConfigureAwait(false);
    }
}
