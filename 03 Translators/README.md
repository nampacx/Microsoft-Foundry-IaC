# Translators

## Services

This folder provisions two Azure AI services in the same resource group (Sweden Central):

- Text Translation account (kind: TextTranslation, SKU: F0) for the standard Translator endpoint.
- Foundry AI Services account (kind: AIServices, SKU: S0) with project management enabled and a sample Foundry project.

Both accounts expose Translator-compatible endpoints.

## Notebook demo

The notebook [TranslatorSample.ipynb](TranslatorSample.ipynb) demonstrates that both endpoints return the same translation result by using the same target language and input text against each endpoint in turn.

What it shows:

- Uses `DefaultAzureCredential` with the Text Translation client.
- Translates the same `textToTranslate` to the same `targetLanguage`.
- Runs once with the Translator endpoint and again with the Foundry endpoint (toggle the `endpoint` assignment).
- Expected output: identical translated text from both calls.

Tip: If you want to verify side-by-side, you can copy the cell and set different `endpoint` values, then compare the printed outputs.
