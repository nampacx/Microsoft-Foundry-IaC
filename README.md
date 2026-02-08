# Microsoft Foundry Infrastructure as Code

This repository contains Terraform configurations for deploying Microsoft Foundry (AI Foundry) infrastructure on Azure using Azure Verified Modules (AVM).

## Overview

This IaC solution deploys:
- Azure Resource Group
- Microsoft AI Foundry Hub
- AI Foundry Project
- Supporting resources (automatically provisioned by the AVM module)

## Prerequisites

- Azure subscription
- Terraform >= 1.12.0
- Azure CLI (for local development)
- GitHub repository secrets configured (for CI/CD)

## Quick Start

### Local Deployment

1. **Clone the repository**
   ```bash
   git clone https://github.com/nampacx/Microsoft-Foundry-IaC.git
   cd Microsoft-Foundry-IaC
   ```

2. **Configure variables**
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your values
   ```

3. **Login to Azure**
   ```bash
   az login
   az account set --subscription <subscription-id>
   ```

4. **Initialize Terraform**
   ```bash
   terraform init
   ```

5. **Plan the deployment**
   ```bash
   terraform plan
   ```

6. **Apply the configuration**
   ```bash
   terraform apply
   ```

### GitHub Actions Deployment

The repository includes a GitHub Actions workflow for automated deployment.

#### Setup

1. **Configure Azure Service Principal with OIDC**
   
   Create an Azure AD App Registration and configure federated credentials for GitHub Actions:
   ```bash
   # Create service principal
   az ad sp create-for-rbac --name "github-foundry-iac" \
     --role contributor \
     --scopes /subscriptions/<subscription-id>
   
   # Configure federated credentials (replace values)
   az ad app federated-credential create \
     --id <app-id> \
     --parameters '{
       "name": "github-actions",
       "issuer": "https://token.actions.githubusercontent.com",
       "subject": "repo:nampacx/Microsoft-Foundry-IaC:ref:refs/heads/main",
       "audiences": ["api://AzureADTokenExchange"]
     }'
   ```

2. **Configure GitHub Secrets**
   
   Add the following secrets to your GitHub repository:
   - `AZURE_CLIENT_ID`: Application (client) ID
   - `AZURE_TENANT_ID`: Directory (tenant) ID
   - `AZURE_SUBSCRIPTION_ID`: Azure subscription ID

3. **Trigger Deployment**
   
   The workflow runs automatically on:
   - Push to `main` branch (applies changes)
   - Pull requests (plans only)
   - Manual trigger via workflow_dispatch

## Architecture

The deployment uses the [Azure Verified Module for AI Foundry](https://registry.terraform.io/modules/Azure/avm-ptn-aiml-ai-foundry/azurerm/latest) which provisions:

- **AI Foundry Hub**: Central management hub for AI workloads
- **AI Foundry Project**: Isolated workspace for AI development
- **Storage Account**: For data and model storage
- **Key Vault**: For secrets management
- **Application Insights**: For monitoring and telemetry

## Configuration

### Variables

Key variables in `variables.tf`:

| Variable | Description | Default |
|----------|-------------|---------|
| `location` | Azure region | `eastus` |
| `resource_group_name` | Resource group name | `rg-foundry-demo` |
| `foundry_name` | AI Foundry hub name | `foundry-hub` |
| `project_name` | AI Foundry project name | `foundry-project` |
| `tags` | Resource tags | See variables.tf |

### Outputs

The deployment provides the following outputs:

- `resource_group_name`: Name of the created resource group
- `ai_foundry_id`: ID of the AI Foundry hub
- `ai_foundry_name`: Name of the AI Foundry hub
- `ai_foundry_project_id`: ID of the AI Foundry project
- `ai_foundry_project_name`: Name of the AI Foundry project
- `location`: Deployment region

## Providers

This configuration uses:

- **azurerm** (~> 4.0): HashiCorp Azure provider
- **azapi** (~> 2.0): Azure API provider for latest features
- **random** (~> 3.6): For generating unique names

## Security

- Uses Azure OIDC for GitHub Actions authentication (no stored credentials)
- Implements Azure RBAC for access control
- Secrets managed in Azure Key Vault
- Terraform state should be stored in Azure Storage with encryption

## Contributing

1. Create a feature branch
2. Make your changes
3. Submit a pull request
4. The GitHub Actions workflow will run `terraform plan`
5. After review and merge to main, changes are automatically applied

## License

This project is licensed under the MIT License.

## Resources

- [Azure Verified Modules](https://azure.github.io/Azure-Verified-Modules/)
- [Microsoft Foundry Documentation](https://learn.microsoft.com/en-us/azure/ai-foundry/)
- [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest)
- [Azure API Provider](https://registry.terraform.io/providers/Azure/azapi/latest)