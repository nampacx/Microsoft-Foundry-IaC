output "resource_group_name" {
  description = "Name of the resource group"
  value       = local.resource_group_name
}

output "function_app_name" {
  description = "Name of the Function App"
  value       = azurerm_function_app_flex_consumption.this.name
}

output "function_app_url" {
  description = "Default hostname of the Function App"
  value       = "https://${azurerm_function_app_flex_consumption.this.default_hostname}"
}

output "function_app_identity_principal_id" {
  description = "Principal ID of the Function App's managed identity"
  value       = azurerm_function_app_flex_consumption.this.identity[0].principal_id
}

output "storage_account_name" {
  description = "Name of the storage account"
  value       = azurerm_storage_account.this.name
}

output "application_insights_name" {
  description = "Name of Application Insights"
  value       = azurerm_application_insights.this.name
}

output "application_insights_instrumentation_key" {
  description = "Instrumentation key for Application Insights"
  value       = azurerm_application_insights.this.instrumentation_key
  sensitive   = true
}
