using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;
using nampacx.Services;
using System.Text.Json;

namespace nampacx;

public class TranslateRequest
{
    public string Text { get; set; } = string.Empty;
    public string TargetLanguage { get; set; } = "en";
    public string? SourceLanguage { get; set; }
}

public class Trnaslate
{
    private readonly ILogger<Trnaslate> _logger;
    private readonly ITranslationService _translationService;

    public Trnaslate(ILogger<Trnaslate> logger, ITranslationService translationService)
    {
        _logger = logger;
        _translationService = translationService;
    }

    [Function("Trnaslate")]
    public async Task<IActionResult> Run([HttpTrigger(AuthorizationLevel.Function, "get", "post")] HttpRequest req)
    {
        _logger.LogInformation("C# HTTP trigger function processed a request.");

        string? text = req.Query["text"];
        string targetLanguage = req.Query["target"].FirstOrDefault() ?? "en";
        string? sourceLanguage = req.Query["source"];

        if (req.HasJsonContentType())
        {
            var requestBody = await JsonSerializer.DeserializeAsync<TranslateRequest>(req.Body);
            if (requestBody != null)
            {
                text ??= requestBody.Text;
                targetLanguage = requestBody.TargetLanguage;
                sourceLanguage ??= requestBody.SourceLanguage;
            }
        }

        if (string.IsNullOrEmpty(text))
        {
            return new BadRequestObjectResult("Please provide 'text' to translate.");
        }

        var result = await _translationService.TranslateAsync(text, targetLanguage, sourceLanguage);
        
        return new OkObjectResult(new { original = text, translated = result, targetLanguage });
    }
}