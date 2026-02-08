using Azure.AI.Translation.Text;
using Azure.Identity;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Builder;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Hosting;
using nampacx.Services;

var builder = FunctionsApplication.CreateBuilder(args);

builder.ConfigureFunctionsWebApplication();

// Register Azure credential
builder.Services.AddSingleton<DefaultAzureCredential>();

// Register Translation client
builder.Services.AddSingleton(sp =>
{
    var credential = sp.GetRequiredService<DefaultAzureCredential>();
    var endpoint = new Uri(Environment.GetEnvironmentVariable("TRANSLATOR_ENDPOINT") 
        ?? "https://api.cognitive.microsofttranslator.com");
    return new TextTranslationClient(credential, endpoint);
});

// Register services
builder.Services.AddScoped<ITranslationService, TranslationService>();

builder.Services
    .AddApplicationInsightsTelemetryWorkerService()
    .ConfigureFunctionsApplicationInsights()
    .Configure<LoggerFilterOptions>(options =>
        {
            LoggerFilterRule? defaultRule = options.Rules.FirstOrDefault(rule => 
                rule.ProviderName == "Microsoft.Extensions.Logging.ApplicationInsights.ApplicationInsightsLoggerProvider");
            if (defaultRule is not null)
            {
                options.Rules.Remove(defaultRule);
            }
        });

builder.Build().Run();
