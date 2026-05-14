variable "tenancy_ocid" {
  type = string
}

variable "user_ocid" {
  type = string
}

variable "fingerprint" {
  type = string
}

variable "private_key_path" {
  type = string
}

variable "region" {
  type = string
}

variable "compartment_ocid" {
  type = string
}

variable "operator_client_cidr" {
  description = "Public CIDR of the operator workstation allowed to use Bastion, for example 198.51.100.10/32."
  type        = string
}

variable "bastion_plugin_wait_duration" {
  description = "How long to wait after instance creation before creating the managed SSH Bastion session."
  type        = string
  default     = "600s"
}
