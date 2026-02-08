provider "azurerm" {
  features {}
}

variable "tags" {
  type    = map(string)
  default = { "environment" = "test" }
}

variable "text_translator_name" {
  type        = string
  description = "Base name used for the Foundry cognitive account and custom subdomain."
  default     = "kk-tt"
}

variable "foundry_name" {
  type        = string
  description = "Base name used for the Foundry cognitive account and custom subdomain."
  default     = "kk-tt-foundry"
}


resource "azurerm_resource_group" "text_translator" {
  name     = "rg-${var.text_translator_name}"
  location = "Sweden Central"
}

resource "azurerm_cognitive_account" "text_translator" {
  name                  = var.text_translator_name
  custom_subdomain_name = var.text_translator_name
  location              = azurerm_resource_group.text_translator.location
  resource_group_name   = azurerm_resource_group.text_translator.name
  kind                  = "TextTranslation"
  sku_name              = "F0"

  tags = var.tags
}

resource "azurerm_cognitive_account" "foundry" {
  name                       = var.foundry_name
  custom_subdomain_name      = var.foundry_name
  location                   = azurerm_resource_group.text_translator.location
  resource_group_name        = azurerm_resource_group.text_translator.name
  kind                       = "AIServices"
  sku_name                   = "S0"
  project_management_enabled = true

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

resource "azurerm_cognitive_account_project" "foundry" {
  name                 = "${var.foundry_name}-project"
  cognitive_account_id = azurerm_cognitive_account.foundry.id
  location             = azurerm_resource_group.text_translator.location
  description          = "Foundry cognitive services project"
  display_name         = "Sample Project"

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

output "text_translator_endpoint" {
  value       = "https:/${azurerm_cognitive_account.text_translator.custom_subdomain_name}.cognitiveservices.azure.com"
    description = "Endpoint for the Text Translation cognitive account."
}

output "foundry_endpoint" {
  value       = "https:/${azurerm_cognitive_account.foundry.custom_subdomain_name}.cognitiveservices.azure.com"
    description = "Endpoint for the Foundry cognitive account."
}