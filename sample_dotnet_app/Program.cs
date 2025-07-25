using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Hosting;
using System.Reflection;

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

var version = Assembly.GetExecutingAssembly().GetName().Version?.ToString() ?? "Unknown";

app.MapGet("/", () => $"Hello from C# microservice version {version}!");

app.MapGet("/version", () => 
{
    var versionLocal = Assembly.GetExecutingAssembly().GetName().Version?.ToString() ?? "Unknown";
    return $"Version: {versionLocal}";
});

app.Run();