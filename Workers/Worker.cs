using System.Diagnostics;
using Microsoft.Extensions.Options;

namespace SampleService.Workers;

public class Worker : BackgroundService
{
    private readonly ILogger<Worker> _logger;
    private readonly WorkerSettings _settings;
    private readonly TimeSpan _interval;

    public Worker(ILogger<Worker> logger, IOptions<WorkerSettings> settings)
    {
        _logger = logger;
        _settings = settings.Value;
        _interval = TimeSpan.FromHours(_settings.IntervalHours);
        
        _logger.LogInformation("Worker configured with interval: {hours} hours", _settings.IntervalHours);
    }

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        while (!stoppingToken.IsCancellationRequested)
        {
            try
            {
                _logger.LogInformation("Worker executing PowerShell script at: {time}", DateTimeOffset.Now);
                
                await RunPowerShellScriptAsync(stoppingToken);
                
                _logger.LogInformation("PowerShell script execution completed. Next execution in {hours} hours.", _settings.IntervalHours);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error occurred while executing PowerShell script");
            }

            // Next execution
            await Task.Delay(_interval, stoppingToken);
        }
    }

    private async Task RunPowerShellScriptAsync(CancellationToken cancellationToken)
    {
        string scriptPath = _settings.ScriptPath;
        
        if (string.IsNullOrWhiteSpace(scriptPath))
        {
            _logger.LogError("Script path is not configured in settings");
            return;
        }
        
        var processStartInfo = new ProcessStartInfo
        {
            FileName = "powershell.exe",
            Arguments = $"-ExecutionPolicy Bypass -File \"{scriptPath}\"",
            UseShellExecute = false,
            RedirectStandardOutput = true,
            RedirectStandardError = true,
            CreateNoWindow = true
        };

        using var process = new Process();
        process.StartInfo = processStartInfo;

        try
        {
            _logger.LogInformation("Starting PowerShell script: {scriptPath}", scriptPath);
            
            process.Start();
            
            var outputTask = process.StandardOutput.ReadToEndAsync();
            var errorTask = process.StandardError.ReadToEndAsync();
            
            await process.WaitForExitAsync(cancellationToken);
            
            var output = await outputTask;
            var error = await errorTask;
            
            if (process.ExitCode == 0)
            {
                _logger.LogInformation("PowerShell script completed successfully");
                if (!string.IsNullOrWhiteSpace(output))
                {
                    _logger.LogInformation("Script output: {output}", output);
                }
            }
            else
            {
                _logger.LogError("PowerShell script failed with exit code: {exitCode}", process.ExitCode);
                if (!string.IsNullOrWhiteSpace(error))
                {
                    _logger.LogError("Script error: {error}", error);
                }
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Failed to execute PowerShell script");
            throw;
        }
    }
}
