output "resource_group_name" {
  description = "The name of the resource group"
  value       = azurerm_resource_group.this.name
}

output "ai_foundry_id" {
  description = "The ID of the AI Foundry hub"
  value       = module.ai_foundry.ai_foundry_id
}

output "ai_foundry_name" {
  description = "The name of the AI Foundry hub"
  value       = module.ai_foundry.ai_foundry_name
}

output "ai_foundry_project_id" {
  description = "The IDs of the AI Foundry projects"
  value       = module.ai_foundry.ai_foundry_project_id
}

output "ai_foundry_project_name" {
  description = "The names of the AI Foundry projects"
  value       = module.ai_foundry.ai_foundry_project_name
}

output "location" {
  description = "The Azure region where resources are deployed"
  value       = var.location
}
