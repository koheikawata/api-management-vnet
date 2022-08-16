using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Xunit;
using Moq;
using WeatherAPI.Interfaces;
using WeatherAPI;
using WeatherAPI.Controllers;
using Microsoft.Extensions.Logging;
using Microsoft.AspNetCore.Mvc;
using MockQueryable.Moq;

namespace WeatherAPITests.Controllers;

public class WeatherforecastControllerTests
{
    [Fact]
    public async Task Get_Success_WeatherList()
    {
        // Arrange
        Mock<ISqlRepository> mockedSqlRepository = new ();
        Mock<IMessageService> mockedMessageService = new ();
        Mock<ILogger<WeatherforecastController>> mockedLogger = new ();
        List<Weatherforecast> weatherList = new ()
        {
            new Weatherforecast()
            {
                Id = "1111",
                Country = "Japan",
                City = "Tokyo",
                TemperatureC = 28,
                Summary = "Sunny",
            },
            new Weatherforecast()
            {
                Id = "2222",
                Country = "France",
                City = "Paris",
                TemperatureC = 15,
                Summary = "Cloudy",
            },
        };
        mockedSqlRepository.Setup(x => x.GetWeatherforecastListAsync()).ReturnsAsync(weatherList);
        WeatherforecastController weatherforecastController = new (mockedSqlRepository.Object, mockedMessageService.Object, mockedLogger.Object);
        string expected = "Japan";

        // Act
        ActionResult<List<Weatherforecast>> result = await weatherforecastController.Get();

        // Assert
        Assert.Equal(expected, result!.Value!.Find(w => w.Id == "1111")!.Country);
        mockedSqlRepository.Verify(x => x.GetWeatherforecastListAsync(), Times.Once);
    }

    [Fact]
    public async Task Post_Success_Weatherforecast()
    {
        // Arrange
        Mock<ISqlRepository> mockedSqlRepository = new ();
        Mock<IMessageService> mockedMessageService = new ();
        Mock<ILogger<WeatherforecastController>> mockedLogger = new ();

        string passedId = String.Empty;
        mockedSqlRepository.Setup(x => x.AddWeatherforecastAsync(It.IsAny<Weatherforecast>()))
            .Callback<Weatherforecast>(w => passedId = w.Id!)
            .ReturnsAsync(() => new Weatherforecast() { Id = passedId });
        WeatherforecastController weatherforecastController = new (mockedSqlRepository.Object, mockedMessageService.Object, mockedLogger.Object);

        // Act
        IActionResult result = await weatherforecastController.Post(new Weatherforecast());

        // Assert
        CreatedResult createdResult = Assert.IsType<CreatedResult>(result);
        Assert.Equal(201, createdResult.StatusCode);
        Weatherforecast createdWeatherforecast = Assert.IsAssignableFrom<Weatherforecast>(createdResult.Value);
        Assert.Equal(passedId, createdWeatherforecast.Id);
    }

    [Fact]
    public async Task Post_InputNull_BadRequest()
    {
        // Arrange
        Mock<ISqlRepository> mockedSqlRepository = new ();
        Mock<IMessageService> mockedMessageService = new ();
        Mock<ILogger<WeatherforecastController>> mockedLogger = new ();

        Weatherforecast? inputWeatherforecast = null;
        string passedMessage = String.Empty;

        WeatherforecastController weatherforecastController = new (mockedSqlRepository.Object, mockedMessageService.Object, mockedLogger.Object);

        // Act
        IActionResult result = await weatherforecastController.Post(inputWeatherforecast!);

        // Assert
        Assert.True(result is BadRequestResult);
    }

    [Fact]
    public async Task Delete_Success_NoContent()
    {
        // Arrange
        Mock<ISqlRepository> mockedSqlRepository = new ();
        Mock<IMessageService> mockedMessageService = new ();
        Mock<ILogger<WeatherforecastController>> mockedLogger = new ();

        Weatherforecast inputWeatherforecast = new ()
        {
            Id = "1111",
        };

        List<Weatherforecast> weatherList = new ()
        {
            new Weatherforecast { Id = "1111", },
            new Weatherforecast { Id = "1111", },
        };
        IQueryable<Weatherforecast> weatherforecastQueryable = weatherList.AsQueryable().BuildMock();
        mockedSqlRepository.Setup(x => x.GetWeatherforecasts(inputWeatherforecast.Id))
            .Returns(weatherforecastQueryable);
        mockedSqlRepository.Setup(x => x.DeleteWeatherforecastAsync(weatherforecastQueryable.FirstOrDefault()!));

        WeatherforecastController weatherforecastController = new(mockedSqlRepository.Object, mockedMessageService.Object, mockedLogger.Object);

        // Act
        IActionResult result = await weatherforecastController.Delete(inputWeatherforecast!);

        // Assert
        Assert.True(result is NoContentResult);
    }

    [Fact]
    public async Task Delete_InputNull_BadRequest()
    {
        // Arrange
        Mock<ISqlRepository> mockedSqlRepository = new ();
        Mock<IMessageService> mockedMessageService = new ();
        Mock<ILogger<WeatherforecastController>> mockedLogger = new ();
        Weatherforecast? inputWeatherforecast = null;

        WeatherforecastController weatherforecastController = new (mockedSqlRepository.Object, mockedMessageService.Object, mockedLogger.Object);

        // Act
        IActionResult result = await weatherforecastController.Delete(inputWeatherforecast!);

        // Assert
        Assert.True(result is BadRequestResult);
    }

    [Fact]
    public async Task Delete_WeatherNoExists_Problem()
    {
        // Arrange
        Mock<ISqlRepository> mockedSqlRepository = new ();
        Mock<IMessageService> mockedMessageService = new ();
        Mock<ILogger<WeatherforecastController>> mockedLogger = new ();

        Weatherforecast inputWeatherforecast = new ()
        {
            Id = "1111",
        };

        List<Weatherforecast>? weatherList = new ();
        IQueryable<Weatherforecast> weatherforecastQueryable = weatherList!.AsQueryable().BuildMock();
        mockedSqlRepository.Setup(x => x.GetWeatherforecasts(inputWeatherforecast.Id))
            .Returns(weatherforecastQueryable);

        WeatherforecastController weatherforecastController = new (mockedSqlRepository.Object, mockedMessageService.Object, mockedLogger.Object);

        // Act
        IActionResult result = await weatherforecastController.Delete(inputWeatherforecast!);

        // Assert
        Assert.True(result is ObjectResult);
    }
}
