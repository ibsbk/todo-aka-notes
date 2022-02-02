namespace WebApplication7.Models
{
    public class Note
    {
        public int id { get; set; }
        public string note { get; set; } = string.Empty;
        public DateTime created_at { get; set; }
        public int user_id { get; set; }
    }
}
