provider "azurerm" {
  features {}
}

variable "tags" {
  type    = map(string)
  default = { "environment" = "test" }
}

variable "form_recognizer_name" {
  type        = string
  description = "Base name used for the Foundry cognitive account and custom subdomain."
  default = "kk-form-recognizer"
}

resource "azurerm_resource_group" "form_recognizer" {
  name     = "rg-${var.form_recognizer_name}"
  location = "Sweden Central"
}

resource "azurerm_cognitive_account" "form_recognizer" {
  name                       = var.form_recognizer_name
  location                   = azurerm_resource_group.form_recognizer.location
  resource_group_name        = azurerm_resource_group.form_recognizer.name
  kind                       = "FormRecognizer"
  sku_name                   = "S0"

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}