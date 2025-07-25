using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Hosting;
using System.Reflection;

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

app.MapGet("/", () => "Hello from C# microservice!");

// New endpoint to return version
app.MapGet("/version", () => 
{
    var version = Assembly.GetExecutingAssembly().GetName().Version?.ToString() ?? "Unknown";
    return $"Version: {version}";
});

app.Run();