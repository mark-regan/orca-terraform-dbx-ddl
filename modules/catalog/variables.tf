variable "name" {
  description = "Name of the catalog"
  type        = string
}

variable "comment" {
  description = "Comment for the catalog"
  type        = string
  default     = null
}

variable "storage_root" {
  description = "Storage root URL for managed tables (e.g., abfss://container@storage.dfs.core.windows.net/path)"
  type        = string
  default     = null
}

variable "provider_name" {
  description = "Provider name for Delta Sharing"
  type        = string
  default     = null
}

variable "share_name" {
  description = "Share name for Delta Sharing"
  type        = string
  default     = null
}

variable "connection_name" {
  description = "Connection name for foreign catalogs"
  type        = string
  default     = null
}

variable "properties" {
  description = "Properties for the catalog"
  type        = map(string)
  default     = {}
}

variable "owner" {
  description = "Owner of the catalog"
  type        = string
  default     = null
}

variable "force_destroy" {
  description = "Force destroy the catalog even if it contains schemas and tables"
  type        = bool
  default     = false
}

variable "grants" {
  description = "List of grants for the catalog"
  type = list(object({
    principal  = string
    privileges = list(string)
  }))
  default = []
}

variable "schemas" {
  description = "Map of schemas to create in this catalog"
  type = map(object({
    comment       = optional(string)
    properties    = optional(map(string), {})
    owner         = optional(string)
    force_destroy = optional(bool, false)
    grants = optional(list(object({
      principal  = string
      privileges = list(string)
    })), [])
  }))
  default = {}
}