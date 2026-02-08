terraform {
  required_version = ">= 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

locals {
  resource_prefix = "${var.project_name}-${var.environment}"
  default_tags = merge(var.tags, {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  })
}

# Resource Group
resource "azurerm_resource_group" "this" {
  count    = var.resource_group_name == "" ? 1 : 0
  name     = "rg-${local.resource_prefix}"
  location = var.location
  tags     = local.default_tags
}

data "azurerm_resource_group" "existing" {
  count = var.resource_group_name != "" ? 1 : 0
  name  = var.resource_group_name
}

locals {
  resource_group_name     = var.resource_group_name != "" ? data.azurerm_resource_group.existing[0].name : azurerm_resource_group.this[0].name
  resource_group_location = var.resource_group_name != "" ? data.azurerm_resource_group.existing[0].location : azurerm_resource_group.this[0].location
}

# Random suffix for globally unique names
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

# Storage Account for Function App
resource "azurerm_storage_account" "this" {
  name                     = "st${random_string.suffix.result}"
  resource_group_name      = local.resource_group_name
  location                 = local.resource_group_location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  tags                     = local.default_tags
}

# Blob container for Flex Consumption deployment
resource "azurerm_storage_container" "deployment" {
  name                  = "deployments"
  storage_account_id    = azurerm_storage_account.this.id
  container_access_type = "private"
}

# Application Insights
resource "azurerm_log_analytics_workspace" "this" {
  name                = "log-${local.resource_prefix}"
  resource_group_name = local.resource_group_name
  location            = local.resource_group_location
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = local.default_tags
}

resource "azurerm_application_insights" "this" {
  name                = "appi-${local.resource_prefix}"
  resource_group_name = local.resource_group_name
  location            = local.resource_group_location
  workspace_id        = azurerm_log_analytics_workspace.this.id
  application_type    = "web"
  tags                = local.default_tags
}

# App Service Plan - Flex Consumption
resource "azurerm_service_plan" "this" {
  name                = "asp-${local.resource_prefix}"
  resource_group_name = local.resource_group_name
  location            = local.resource_group_location
  os_type             = "Linux"
  sku_name            = "FC1"
  tags                = local.default_tags
}

# Linux Function App - Flex Consumption
resource "azurerm_function_app_flex_consumption" "this" {
  name                = "func-${local.resource_prefix}"
  resource_group_name = local.resource_group_name
  location            = local.resource_group_location
  service_plan_id     = azurerm_service_plan.this.id
  tags                = local.default_tags

  storage_container_type      = "blobContainer"
  storage_container_endpoint  = "${azurerm_storage_account.this.primary_blob_endpoint}${azurerm_storage_container.deployment.name}"
  storage_authentication_type = "SystemAssignedIdentity"

  runtime_name    = "dotnet-isolated"
  runtime_version = var.dotnet_version

  site_config {
    application_insights_connection_string = azurerm_application_insights.this.connection_string
  }

  app_settings = {
    "TRANSLATOR_ENDPOINT" = var.translator_endpoint
  }

  identity {
    type = "SystemAssigned"
  }
}

# Role assignment for Function App to access Storage
resource "azurerm_role_assignment" "function_storage_blob" {
  scope                = azurerm_storage_account.this.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_function_app_flex_consumption.this.identity[0].principal_id
}
