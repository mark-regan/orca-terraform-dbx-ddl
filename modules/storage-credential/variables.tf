variable "name" {
  description = "Name of the storage credential"
  type        = string
}

variable "comment" {
  description = "Comment for the storage credential"
  type        = string
  default     = null
}

variable "access_connector_id" {
  description = "Azure Access Connector resource ID for managed identity"
  type        = string
}

variable "owner" {
  description = "Owner of the storage credential"
  type        = string
  default     = null
}

variable "force_destroy" {
  description = "Force destroy the storage credential even if it's being used"
  type        = bool
  default     = false
}

variable "grants" {
  description = "List of grants for the storage credential"
  type = list(object({
    principal  = string
    privileges = list(string)
  }))
  default = []
}

variable "prevent_destroy" {
  description = "Prevent destruction of this resource"
  type        = bool
  default     = true
}

variable "ignore_changes_list" {
  description = "List of attributes to ignore changes for"
  type        = list(string)
  default     = []
}