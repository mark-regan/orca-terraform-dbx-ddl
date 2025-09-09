variable "catalog_name" {
  description = "The Unity Catalog name for ORCA tables"
  type        = string
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