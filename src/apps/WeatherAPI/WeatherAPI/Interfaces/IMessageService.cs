namespace WeatherAPI.Interfaces;

public interface IMessageService
{
    public Task SendMessageAsync(Weatherforecast weatherforecast);
}
