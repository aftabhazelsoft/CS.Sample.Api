using Microsoft.EntityFrameworkCore;

namespace CS.Sample.Api
{
    public class SampleDbContext : DbContext
    {
        public SampleDbContext(DbContextOptions options)
            : base(options) { }

        public DbSet<SystemUser> SystemUsers { get; set; }
    }
}
