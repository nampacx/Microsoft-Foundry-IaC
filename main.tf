# Generate random suffix for unique naming
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

# Create Resource Group
resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Deploy Microsoft Foundry using Azure Verified Module
module "ai_foundry" {
  source  = "Azure/avm-ptn-aiml-ai-foundry/azurerm"
  version = "~> 0.10"

  enable_telemetry = var.enable_telemetry

  # Required inputs
  base_name                  = "${var.foundry_name}-${random_string.suffix.result}"
  location                   = var.location
  resource_group_resource_id = azurerm_resource_group.this.id

  # AI Foundry configuration
  ai_foundry = {
    name                    = "${var.foundry_name}-${random_string.suffix.result}"
    create_ai_agent_service = false
  }

  # AI Foundry Project configuration
  ai_projects = {
    default = {
      name                       = var.project_name
      description                = "Default AI Foundry project for development"
      display_name               = var.project_name
      create_project_connections = false
    }
  }

  # BYOR - Bring Your Own Resources (set to false to use module-created resources)
  create_byor = false

  # Private endpoints (set to false for public deployment)
  create_private_endpoints = false

  # Tags
  tags = var.tags

  depends_on = [azurerm_resource_group.this]
}
