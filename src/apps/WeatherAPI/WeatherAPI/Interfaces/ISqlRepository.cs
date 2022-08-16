namespace WeatherAPI.Interfaces
{
    public interface ISqlRepository
    {
        public IQueryable<Weatherforecast> GetWeatherforecasts(string id);
        public Task<List<Weatherforecast>> GetWeatherforecastListAsync();
        public Task<Weatherforecast> AddWeatherforecastAsync(Weatherforecast weatherforecast);
        public Task DeleteWeatherforecastAsync(Weatherforecast weatherforecast);
    }
}
