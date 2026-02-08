provider "azurerm" {
  features {}
}

variable "tags" {
  type    = map(string)
  default = { "environment" = "test" }
}

variable "foundry_name" {
  type        = string
  description = "Base name used for the Foundry cognitive account and custom subdomain."
  default = "kk-smpl-foundry"
}

resource "azurerm_resource_group" "foundry" {
  name     = "rg-${var.foundry_name}"
  location = "Sweden Central"
}

resource "azurerm_cognitive_account" "foundry" {
  name                       = var.foundry_name
  custom_subdomain_name      = var.foundry_name
  location                   = azurerm_resource_group.foundry.location
  resource_group_name        = azurerm_resource_group.foundry.name
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
  location             = azurerm_resource_group.foundry.location
  description          = "Foundry cognitive services project"
  display_name         = "Sample Project"

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

resource "azurerm_cognitive_deployment" "example" {
  name                 = "${var.foundry_name}-deployment"
  cognitive_account_id = azurerm_cognitive_account.foundry.id

  model {
    format  = "OpenAI"
    name    = "gpt-5-mini"
    version = "2025-08-07"
  }

  sku {
    name = "GlobalStandard"
  }
}