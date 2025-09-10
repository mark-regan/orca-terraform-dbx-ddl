terraform {
  required_version = ">= 1.0"
  
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = ">= 1.38.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.1.0"
    }
  }

  backend "azurerm" {
    # Backend configuration will be provided via backend config file
  }
}

provider "databricks" {
  # Provider configuration will use environment variables or Azure authentication
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
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

