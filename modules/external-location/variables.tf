variable "name" {
  description = "Name of the external location"
  type        = string
}

variable "url" {
  description = "Azure storage URL (e.g., abfss://container@storage.dfs.core.windows.net/path)"
  type        = string
}

variable "credential_name" {
  description = "Name of the storage credential to use"
  type        = string
}

variable "comment" {
  description = "Comment for the external location"
  type        = string
  default     = null
}

variable "skip_validation" {
  description = "Skip validation of the external location"
  type        = bool
  default     = false
}

variable "read_only" {
  description = "Whether the external location is read-only"
  type        = bool
  default     = false
}

variable "owner" {
  description = "Owner of the external location"
  type        = string
  default     = null
}

variable "force_destroy" {
  description = "Force destroy the external location even if it contains data"
  type        = bool
  default     = false
}

variable "grants" {
  description = "List of grants for the external location"
  type = list(object({
    principal  = string
    privileges = list(string)
  }))
  default = []
}