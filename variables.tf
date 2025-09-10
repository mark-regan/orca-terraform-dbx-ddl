variable "catalog_name" {
  description = "The Unity Catalog name for ORCA tables (for backward compatibility)"
  type        = string
  default     = ""
}

variable "metadata_schema_name" {
  description = "The schema name for ORCA metadata tables"
  type        = string
  default     = "orca_metadata"
}

variable "runtime_schema_name" {
  description = "The schema name for ORCA runtime tables"
  type        = string
  default     = "orca_runtime"
}

variable "environment" {
  description = "Environment name (dev, test, uat, prod)"
  type        = string
}

variable "enable_cdf_for_runtime" {
  description = "Enable Change Data Feed for runtime tables"
  type        = bool
  default     = true
}

variable "enable_cdf_for_metadata" {
  description = "Enable Change Data Feed for metadata tables"
  type        = bool
  default     = false
}

# Azure Storage Variables
variable "storage_account_name" {
  description = "Azure Storage Account name for data lake"
  type        = string
}

# Access Connector Variables for Managed Identities
variable "bronze_access_connector_id" {
  description = "Azure Access Connector resource ID for Bronze layer"
  type        = string
  default     = ""
}

variable "silver_access_connector_id" {
  description = "Azure Access Connector resource ID for Silver layer"
  type        = string
  default     = ""
}

variable "gold_access_connector_id" {
  description = "Azure Access Connector resource ID for Gold layer"
  type        = string
  default     = ""
}

variable "storage_connector_id" {
  description = "Azure Access Connector resource ID for storage credential"
  type        = string
}

variable "ad_group_environment" {
  description = "Azure AD group environment suffix (e.g., DEV, UAT, PROD)"
  type        = string
}

variable "orca_catalog" {
  description = "ORCA catalog name"
  type        = string
}

variable "orca_metadata_schema" {
  description = "ORCA metadata schema name"
  type        = string
}

variable "orca_runtime_schema" {
  description = "ORCA runtime schema name"
  type        = string
}

variable "bronze_catalog" {
  description = "Bronze catalog name"
  type        = string
}

variable "silver_catalog" {
  description = "Silver catalog name"
  type        = string
}

variable "gold_catalog" {
  description = "Gold catalog name"
  type        = string
}

variable "platinum_catalog" {
  description = "Platinum catalog name"
  type        = string
}

