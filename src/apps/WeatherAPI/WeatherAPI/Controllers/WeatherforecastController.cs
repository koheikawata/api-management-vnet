using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Swashbuckle.AspNetCore.Annotations;
using WeatherAPI.Interfaces;

namespace WeatherAPI.Controllers;

[ApiController]
[Route("[controller]")]
public class WeatherforecastController : ControllerBase
{
    private readonly ISqlRepository sqlRepository;
    private readonly IMessageService messageService;
    private readonly ILogger<WeatherforecastController> logger;

    public WeatherforecastController(ISqlRepository sqlRepository, IMessageService messageService, ILogger<WeatherforecastController> logger) 
    {
        this.sqlRepository = sqlRepository;
        this.messageService = messageService;
        this.logger = logger;
    }

    /// <summary>
    /// Get a list of weatherforecasts
    /// </summary>
    /// <returns>A newly created weatherforecast list </returns>
    /// <remarks>
    /// Sample request:
    ///
    ///     GET /weatherforecast
    ///
    /// </remarks>
    [HttpGet]
    [Authorize]
    [SwaggerResponse(StatusCodes.Status200OK, Type = typeof(List<Weatherforecast>), Description = "Succeed")]
    public async Task<ActionResult<List<Weatherforecast>>> Get()
    {
        return await this.sqlRepository.GetWeatherforecastListAsync().ConfigureAwait(false);
    }

    /// <summary>
    /// Create a weatherforecast
    /// </summary>
    /// <param name="weatherforecast">weatherforecast</param>
    /// <returns>A newly created weatherforecast</returns>
    /// <remarks>
    /// Sample request:
    ///
    ///     POST /weatherforecast
    ///     {
    ///          "country": "Japan",
    ///          "city": "Tokyo",
    ///          "temperatureC": 18,
    ///          "summary": "Sunny"
    ///     }
    ///
    /// </remarks>
    [HttpPost]
    [Authorize]
    [SwaggerResponse(StatusCodes.Status200OK, Type = typeof(Weatherforecast), Description = "Succeed")]
    public async Task<IActionResult> Post([FromBody] Weatherforecast weatherforecast)
    {
        if (weatherforecast is null)
        {
            this.logger.LogInformation($"The request message is invalid");
            return this.BadRequest();
        }

        weatherforecast.Id = Guid.NewGuid().ToString();
        Weatherforecast addedWeatherforecast = await this.sqlRepository.AddWeatherforecastAsync(weatherforecast).ConfigureAwait(false);

        return this.Created("weatherforecast", addedWeatherforecast);
    }

    /// <summary>
    /// Delete a list of weatherforecast
    /// </summary>
    /// <param name="weatherforecast">weatherforecast</param>
    /// <remarks>
    /// Sample request:
    ///
    ///     DELETE /weatherforecast
    ///     {
    ///          "id": "0e048622-0258-434c-839c-9ec2768658b9"
    ///     }
    ///
    /// </remarks>
    [HttpDelete]
    [Authorize]
    [SwaggerResponse(StatusCodes.Status200OK, Type = typeof(Weatherforecast), Description = "Succeed")]
    public async Task<IActionResult> Delete([FromBody] Weatherforecast weatherforecast)
    {
        if (weatherforecast is null)
        {
            this.logger.LogInformation($"The request message is invalid");
            return this.BadRequest();
        }

        Weatherforecast? existingWeatherforecast = await this.sqlRepository.GetWeatherforecasts(weatherforecast.Id!).FirstOrDefaultAsync();
        if (existingWeatherforecast is null)
        {
            this.logger.LogInformation($"The target record is not found");
            return this.Problem();
        }

        await this.sqlRepository.DeleteWeatherforecastAsync(existingWeatherforecast).ConfigureAwait(false);

        return this.NoContent();
    }

    /// <summary>
    /// Send a message to Service Bus
    /// </summary>
    /// <param name="weatherforecast">weatherforecast</param>
    /// <remarks>
    /// Sample request:
    ///
    ///     POST /weatherforecast/message
    ///     {
    ///          "country": "Japan",
    ///          "city": "Tokyo",
    ///          "temperatureC": 18,
    ///          "summary": "Sunny"
    ///     }
    ///
    /// </remarks>
    [HttpPost("message")]
    [Authorize]
    [SwaggerResponse(StatusCodes.Status200OK, Type = typeof(Weatherforecast), Description = "Succeed")]
    public async Task<IActionResult> SendMessageAsync([FromBody] Weatherforecast weatherforecast)
    {
        if (weatherforecast is null)
        {
            this.logger.LogInformation($"The request message is invalid");
            return this.BadRequest();
        }

        weatherforecast.Id = Guid.NewGuid().ToString();
        await this.messageService.SendMessageAsync(weatherforecast);

        return this.Ok(weatherforecast);
    }
}