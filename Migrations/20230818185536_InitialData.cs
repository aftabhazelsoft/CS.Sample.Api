using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace CS.Sample.Api.Migrations
{
    /// <inheritdoc />
    public partial class InitialData : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.Sql("INSERT INTO [SystemUsers] ([FirstName],[LastName]) VALUES ('Aftab','Ahmad');" +
                "INSERT INTO [SystemUsers] ([FirstName],[LastName]) VALUES ('Usman','Nisar');");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {

        }
    }
}
