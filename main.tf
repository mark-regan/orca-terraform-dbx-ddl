terraform {
  required_version = ">= 1.0"
  
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = ">= 1.38.0"
    }
  }

  backend "azurerm" {
    # Backend configuration will be provided via backend config file
  }
}

provider "databricks" {
  # Provider configuration will use environment variables or Azure authentication
}

# Create schemas if they don't exist
resource "databricks_schema" "orca_metadata" {
  catalog_name = var.catalog_name
  name         = var.metadata_schema_name
  comment      = "ORCA Metadata Schema - Configuration and Definitions"
  
  properties = {
    "managed_by" = "terraform"
    "purpose"    = "orca_metadata"
  }
}

resource "databricks_schema" "orca_runtime" {
  catalog_name = var.catalog_name
  name         = var.runtime_schema_name
  comment      = "ORCA Runtime Schema - Execution Tracking and Monitoring"
  
  properties = {
    "managed_by" = "terraform"
    "purpose"    = "orca_runtime"
  }
}

# ================================================================================
# METADATA TABLES
# ================================================================================

module "feed" {
  source = "./tables/orca_catalog/orca_metadata/feed"
  
  catalog_name = var.catalog_name
  metadata_schema_name = var.metadata_schema_name
  enable_cdf_for_metadata = var.enable_cdf_for_metadata
  
  depends_on = [databricks_schema.orca_metadata]
}

module "feed_alert" {
  source = "./tables/orca_catalog/orca_metadata/feed_alert"
  
  catalog_name = var.catalog_name
  metadata_schema_name = var.metadata_schema_name
  enable_cdf_for_metadata = var.enable_cdf_for_metadata
  
  depends_on = [databricks_schema.orca_metadata]
}

module "alert" {
  source = "./tables/orca_catalog/orca_metadata/alert"
  
  catalog_name = var.catalog_name
  metadata_schema_name = var.metadata_schema_name
  enable_cdf_for_metadata = var.enable_cdf_for_metadata
  
  depends_on = [databricks_schema.orca_metadata]
}

module "feed_dependencies" {
  source = "./tables/orca_catalog/orca_metadata/feed_dependencies"
  
  catalog_name = var.catalog_name
  metadata_schema_name = var.metadata_schema_name
  enable_cdf_for_metadata = var.enable_cdf_for_metadata
  
  depends_on = [databricks_schema.orca_metadata]
}

module "feed_step" {
  source = "./tables/orca_catalog/orca_metadata/feed_step"
  
  catalog_name = var.catalog_name
  metadata_schema_name = var.metadata_schema_name
  enable_cdf_for_metadata = var.enable_cdf_for_metadata
  
  depends_on = [databricks_schema.orca_metadata]
}

module "feed_step_parameter" {
  source = "./tables/orca_catalog/orca_metadata/feed_step_parameter"
  
  catalog_name = var.catalog_name
  metadata_schema_name = var.metadata_schema_name
  enable_cdf_for_metadata = var.enable_cdf_for_metadata
  
  depends_on = [databricks_schema.orca_metadata]
}

module "feed_parameter" {
  source = "./tables/orca_catalog/orca_metadata/feed_parameter"
  
  catalog_name = var.catalog_name
  metadata_schema_name = var.metadata_schema_name
  enable_cdf_for_metadata = var.enable_cdf_for_metadata
  
  depends_on = [databricks_schema.orca_metadata]
}

module "dataset" {
  source = "./tables/orca_catalog/orca_metadata/dataset"
  
  catalog_name = var.catalog_name
  metadata_schema_name = var.metadata_schema_name
  enable_cdf_for_metadata = var.enable_cdf_for_metadata
  
  depends_on = [databricks_schema.orca_metadata]
}

module "feed_step_dataset" {
  source = "./tables/orca_catalog/orca_metadata/feed_step_dataset"
  
  catalog_name = var.catalog_name
  metadata_schema_name = var.metadata_schema_name
  enable_cdf_for_metadata = var.enable_cdf_for_metadata
  
  depends_on = [databricks_schema.orca_metadata]
}

module "feed_step_dataset_transformation" {
  source = "./tables/orca_catalog/orca_metadata/feed_step_dataset_transformation"
  
  catalog_name = var.catalog_name
  metadata_schema_name = var.metadata_schema_name
  enable_cdf_for_metadata = var.enable_cdf_for_metadata
  
  depends_on = [databricks_schema.orca_metadata]
}

module "dataset_schema" {
  source = "./tables/orca_catalog/orca_metadata/dataset_schema"
  
  catalog_name = var.catalog_name
  metadata_schema_name = var.metadata_schema_name
  enable_cdf_for_metadata = var.enable_cdf_for_metadata
  
  depends_on = [databricks_schema.orca_metadata]
}

module "dataset_parameter" {
  source = "./tables/orca_catalog/orca_metadata/dataset_parameter"
  
  catalog_name = var.catalog_name
  metadata_schema_name = var.metadata_schema_name
  enable_cdf_for_metadata = var.enable_cdf_for_metadata
  
  depends_on = [databricks_schema.orca_metadata]
}

module "holiday_calendar" {
  source = "./tables/orca_catalog/orca_metadata/holiday_calendar"
  
  catalog_name = var.catalog_name
  metadata_schema_name = var.metadata_schema_name
  enable_cdf_for_metadata = var.enable_cdf_for_metadata
  
  depends_on = [databricks_schema.orca_metadata]
}

module "code_version" {
  source = "./tables/orca_catalog/orca_metadata/code_version"
  
  catalog_name = var.catalog_name
  metadata_schema_name = var.metadata_schema_name
  enable_cdf_for_metadata = var.enable_cdf_for_metadata
  
  depends_on = [databricks_schema.orca_metadata]
}

# ================================================================================
# RUNTIME TABLES
# ================================================================================

module "feed_schedule" {
  source = "./tables/orca_catalog/orca_runtime/feed_schedule"
  
  catalog_name = var.catalog_name
  runtime_schema_name = var.runtime_schema_name
  enable_cdf_for_runtime = var.enable_cdf_for_runtime
  
  depends_on = [databricks_schema.orca_runtime]
}

module "feed_instance" {
  source = "./tables/orca_catalog/orca_runtime/feed_instance"
  
  catalog_name = var.catalog_name
  runtime_schema_name = var.runtime_schema_name
  enable_cdf_for_runtime = var.enable_cdf_for_runtime
  
  depends_on = [databricks_schema.orca_runtime]
}

module "feed_step_instance" {
  source = "./tables/orca_catalog/orca_runtime/feed_step_instance"
  
  catalog_name = var.catalog_name
  runtime_schema_name = var.runtime_schema_name
  enable_cdf_for_runtime = var.enable_cdf_for_runtime
  
  depends_on = [databricks_schema.orca_runtime]
}

module "dataset_instance" {
  source = "./tables/orca_catalog/orca_runtime/dataset_instance"
  
  catalog_name = var.catalog_name
  runtime_schema_name = var.runtime_schema_name
  enable_cdf_for_runtime = var.enable_cdf_for_runtime
  
  depends_on = [databricks_schema.orca_runtime]
}

module "data_quality_results" {
  source = "./tables/orca_catalog/orca_runtime/data_quality_results"
  
  catalog_name = var.catalog_name
  runtime_schema_name = var.runtime_schema_name
  enable_cdf_for_runtime = var.enable_cdf_for_runtime
  
  depends_on = [databricks_schema.orca_runtime]
}

module "feed_step_metric" {
  source = "./tables/orca_catalog/orca_runtime/feed_step_metric"
  
  catalog_name = var.catalog_name
  runtime_schema_name = var.runtime_schema_name
  enable_cdf_for_runtime = var.enable_cdf_for_runtime
  
  depends_on = [databricks_schema.orca_runtime]
}

module "platform_stop" {
  source = "./tables/orca_catalog/orca_runtime/platform_stop"
  
  catalog_name = var.catalog_name
  runtime_schema_name = var.runtime_schema_name
  enable_cdf_for_runtime = var.enable_cdf_for_runtime
  
  depends_on = [databricks_schema.orca_runtime]
}