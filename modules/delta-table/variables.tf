variable "catalog_name" {
  description = "The name of the Unity Catalog"
  type        = string
}

variable "schema_name" {
  description = "The name of the schema"
  type        = string
}

variable "table_name" {
  description = "The name of the table"
  type        = string
}

variable "table_comment" {
  description = "Comment for the table"
  type        = string
  default     = ""
}

variable "columns" {
  description = "List of column definitions"
  type = list(object({
    name     = string
    type     = string
    nullable = optional(bool, true)
    comment  = optional(string)
  }))
}

variable "primary_key" {
  description = "List of column names that form the primary key"
  type        = list(string)
  default     = []
}

variable "enable_cdf" {
  description = "Enable Change Data Feed for the table"
  type        = bool
  default     = false
}

variable "enable_auto_optimize" {
  description = "Enable auto-optimize for the table"
  type        = bool
  default     = true
}

variable "enable_auto_compact" {
  description = "Enable auto-compact for the table"
  type        = bool
  default     = true
}

variable "table_properties" {
  description = "Additional table properties"
  type        = map(string)
  default     = {}
}

variable "grants" {
  description = "List of grants for the table"
  type = list(object({
    principal  = string
    privileges = list(string)
  }))
  default = []
}