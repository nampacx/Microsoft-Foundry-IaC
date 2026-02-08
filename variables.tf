variable "location" {
  description = "The Azure region where resources will be deployed"
  type        = string
  default     = "eastus"
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
  default     = "rg-foundry-demo"
}

variable "foundry_name" {
  description = "The name of the AI Foundry hub (will be suffixed with random string)"
  type        = string
  default     = "foundry-hub"
}

variable "project_name" {
  description = "The name of the AI Foundry project"
  type        = string
  default     = "foundry-project"
}

variable "tags" {
  description = "A map of tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "Development"
    ManagedBy   = "Terraform"
    Project     = "Microsoft-Foundry"
  }
}

variable "enable_telemetry" {
  description = "Enable telemetry for Azure Verified Modules"
  type        = bool
  default     = true
}
