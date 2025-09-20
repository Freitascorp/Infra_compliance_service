using SampleService.Workers;

var builder = WebApplication.CreateBuilder(args);

// Windows Service
builder.Host.UseWindowsService(options =>
{
    options.ServiceName = "SampleService";
});

// DI from appsettings.json
builder.Services.Configure<WorkerSettings>(
    builder.Configuration.GetSection(WorkerSettings.SectionName));

// Add background service
builder.Services.AddHostedService<Worker>();

var app = builder.Build();

// Configure endpoints
EndpointExtensions.ConfigureEndpoints(app);

app.Run();
