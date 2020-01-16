using Microsoft.Data.Entity;
using Microsoft.Data.Entity.Metadata;

namespace <AppName>.Models
{
    public partial class <TableName>Context : DbContext
    {
        //protected override void OnConfiguring(DbContextOptionsBuilder options)
        //{
        //    options.UseSqlServer(@"Server=<ServerName>;Database=<DatabaseName>;Trusted_Connection=True;");
        //}
		
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<<TableName>>(entity =>
            {
                //Primary Key
				entity.HasKey(e => e.<KeyColumnName>);
				
				//String Type
                entity.Property(e => e.<ColumnName>).HasMaxLength(510);

				//DateTime Type
                entity.Property(e => e.<ColumnName>).HasColumnType("datetime");
                
				//Decimal Type
                entity.Property(e => e.<ColumnName>).HasColumnType("decimal");
                //entity.HasOne(d => d.destinationkeyNavigation).WithMany(p => p.<TableName>).HasForeignKey(d => d.destinationkey);
            });

        }

        public virtual DbSet<<TableName>> <TableName> { get; set; }
        
    }
}