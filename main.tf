terraform {
  required_version = ">= 1.0"
  
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = ">= 1.38.0"
    }
  }

  backend "azurerm" {
    # Backend configuration will be provided via backend config
  }
}

provider "databricks" {
  # Provider configuration for Azure Databricks
  # Will use Azure CLI authentication from the pipeline context
  host = var.databricks_host
  
  # Use Azure CLI authentication (from the managed identity session)
  azure_use_msi = false
  
  # Let Databricks provider detect Azure CLI context
}

# ================================================================================
# STORAGE CREDENTIALS
# ================================================================================
# Storage credentials are defined in storage-credentials.tf

# ================================================================================
# EXTERNAL LOCATIONS
# ================================================================================
# External locations are defined in external-locations.tf

# ================================================================================
# CATALOGS AND SCHEMAS
# ================================================================================
# Catalogs and their schemas are defined in catalogs.tf
# This includes the new catalog module with grant support

