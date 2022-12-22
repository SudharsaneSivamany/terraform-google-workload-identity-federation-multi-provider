variable "pool_id" {
type = string
}

variable "project_id" {
type = string
}

variable "pool_display_name" {
type = string
default = null
}

variable "pool_description" {
type = string
default = null 
}

variable "pool_disabled" {
type = bool
default = false
}

variable "wif_providers" {
type = list(any)
}

variable "service_accounts" {
  type = list(object({
    name           = string
    attribute      = string
    all_identities = bool
  }))
}
