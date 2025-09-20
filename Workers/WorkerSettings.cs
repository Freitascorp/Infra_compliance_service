namespace SampleService.Workers;

public class WorkerSettings
{
    public const string SectionName = "WorkerSettings";
    
    public int IntervalHours { get; set; } = 6;
    public string ScriptPath { get; set; } = string.Empty;
}