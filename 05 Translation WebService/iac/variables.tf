variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "project_name" {
  description = "Name of the project, used as prefix for resources"
  type        = string
  default     = "translator"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "westeurope"
}

variable "resource_group_name" {
  description = "Name of the resource group (leave empty to create new)"
  type        = string
  default     = ""
}

variable "dotnet_version" {
  description = ".NET version for the function app"
  type        = string
  default     = "10.0"
}

variable "translator_endpoint" {
  description = "Azure Translator/Cognitive Services endpoint URL"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
