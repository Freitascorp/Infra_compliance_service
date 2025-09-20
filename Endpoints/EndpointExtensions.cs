public static class EndpointExtensions
{
    public static void ConfigureEndpoints(this WebApplication app)
    {
        // metrics endpoint
        app.MapGet("/machine/metrics", async () =>
        {
            try
            {
                var jsonFilePath = Path.Combine(app.Environment.ContentRootPath, "directories.json");

                if (!File.Exists(jsonFilePath))
                {
                    return Results.NotFound("directories.json file not found");
                }

                var jsonContent = await File.ReadAllTextAsync(jsonFilePath);
                return Results.Content(jsonContent, "application/json");
            }
            catch (Exception ex)
            {
                return Results.Problem($"Error reading directories.json: {ex.Message}");
            }
        });

        // health check endpoint
        app.MapGet("/machine/health", () => Results.Ok(new { status = "healthy", timestamp = DateTimeOffset.Now }));
    }
}