using Microsoft.EntityFrameworkCore;

namespace WebApplication7.Models
{
    public class DBContext : DbContext
    {
        public DbSet<User> users { get; set; }
        public DbSet<Note> notes { get; set; }
        public DBContext()
        {
            Database.EnsureCreated();
        }
        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            optionsBuilder.UseNpgsql("Host=localhost;Port=5432;Database=notes;Username=postgres;Password=toor");
        }
    }
}
