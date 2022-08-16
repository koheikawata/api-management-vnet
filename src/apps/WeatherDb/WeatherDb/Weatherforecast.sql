CREATE TABLE [dbo].[Weatherforecast] (
    [Id] NVARCHAR (256) NOT NULL,
    [Country] NVARCHAR (256) NOT NULL,
    [City] NVARCHAR (256) NULL,
    [TemperatureC] INT, 
    [Summary] NVARCHAR (256) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
)