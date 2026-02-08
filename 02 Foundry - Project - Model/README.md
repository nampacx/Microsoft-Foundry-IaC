# Foundry Project - Model (Azure AI Services)

This Terraform file creates an Azure AI Services cognitive account with project management enabled, an associated project, and a model deployment in Sweden Central. It also creates a resource group and applies basic tags. Both the account and project use system-assigned managed identities.

The deployment targets the OpenAI model gpt-5-mini (version 2025-08-07) using the GlobalStandard SKU, suitable for hosting a model within a Foundry project.
