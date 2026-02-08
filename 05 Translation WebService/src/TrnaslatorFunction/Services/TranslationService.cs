using Azure;
using Azure.AI.Translation.Text;
using Microsoft.Extensions.Logging;

namespace nampacx.Services;

public class TranslationService : ITranslationService
{
    private readonly TextTranslationClient _client;
    private readonly ILogger<TranslationService> _logger;

    public TranslationService(TextTranslationClient client, ILogger<TranslationService> logger)
    {
        _client = client;
        _logger = logger;
    }

    public async Task<string> TranslateAsync(string text, string targetLanguage, string? sourceLanguage = null)
    {
        _logger.LogInformation("Translating text to {TargetLanguage}", targetLanguage);

        var response = await _client.TranslateAsync(targetLanguage, text, sourceLanguage);
        
        var translation = response.Value.FirstOrDefault();
        if (translation?.Translations?.FirstOrDefault() is { } result)
        {
            return result.Text;
        }

        _logger.LogWarning("No translation result returned");
        return text;
    }
}
