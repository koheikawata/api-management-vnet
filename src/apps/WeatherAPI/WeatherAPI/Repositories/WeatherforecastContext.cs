using Microsoft.EntityFrameworkCore;

namespace WeatherAPI.Data
{
    public class WeatherforecastContext : DbContext
    {
        public WeatherforecastContext(DbContextOptions<WeatherforecastContext> options) : base(options)
        {
        }

        public DbSet<Weatherforecast> Weatherforecasts => Set<Weatherforecast>();

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Weatherforecast>().ToTable("Weatherforecast");
        }
    }
}
