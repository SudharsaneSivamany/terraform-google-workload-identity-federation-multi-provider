variable "pool_id" {
  type        = string
  description = "Workload identity federation pool id"
}

variable "project_id" {
  type        = string
  description = "Project ID"
}

variable "pool_display_name" {
  type        = string
  description = "Workload identity federation pool name"
  default     = null
}

variable "pool_description" {
  type        = string
  description = "Workload identity federation pool description"
  default     = null
}

variable "pool_disabled" {
  type        = bool
  description = "Whether workload identity federation pool is disabled"
  default     = false
}

variable "wif_providers" {
  type        = list(any)
  description = "Definition of workload identity federation pool providers"
}

variable "service_accounts" {
  type = list(object({
    name           = string
    attribute      = string
    all_identities = bool
    roles          = list(string)
  }))
  description = "Definition of GCP service accounts to manage"
}
