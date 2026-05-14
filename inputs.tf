variable "name" {
  description = "Name of the OCI Bastion resource."
  type        = string

  validation {
    condition     = length(trimspace(var.name)) > 0
    error_message = "name must not be empty."
  }
}

variable "compartment_ocid" {
  description = "Compartment OCID where the bastion will be created."
  type        = string
}

variable "target_subnet_id" {
  description = "Subnet OCID where the Bastion private endpoint will be attached."
  type        = string
}

variable "client_cidr_block_allow_list" {
  description = "List of client CIDR blocks allowed to open sessions through this bastion."
  type        = list(string)
}

variable "max_session_ttl_in_seconds" {
  description = "Maximum allowed session TTL on the bastion, in seconds. OCI Bastion supports up to 10800 seconds (3 hours)."
  type        = number
  default     = 10800
}

variable "bastion_type" {
  description = "OCI Bastion type."
  type        = string
  default     = "STANDARD"

  validation {
    condition     = contains(["STANDARD"], var.bastion_type)
    error_message = "bastion_type must be STANDARD."
  }
}

variable "create_session" {
  description = "Whether to create an OCI Bastion session together with the bastion."
  type        = bool
  default     = false
}

variable "session_name" {
  description = "Optional display name for the session."
  type        = string
  default     = null
}

variable "session_type" {
  description = "Bastion session type. Supported values are MANAGED_SSH, PORT_FORWARDING, and DYNAMIC_PORT_FORWARDING."
  type        = string
  default     = "MANAGED_SSH"

  validation {
    condition     = contains(["MANAGED_SSH", "PORT_FORWARDING", "DYNAMIC_PORT_FORWARDING"], var.session_type)
    error_message = "session_type must be MANAGED_SSH, PORT_FORWARDING, or DYNAMIC_PORT_FORWARDING."
  }
}

variable "session_ttl_in_seconds" {
  description = "Requested session TTL in seconds."
  type        = number
  default     = 3600
}

variable "ssh_public_key" {
  description = "Public key content in OpenSSH format used by the created session."
  type        = string
  default     = null
}

variable "target_resource_id" {
  description = "Target OCI resource OCID, typically the private compute instance OCID for MANAGED_SSH."
  type        = string
  default     = null
}

variable "target_resource_private_ip_address" {
  description = "Private IP address of the target resource used by the bastion session."
  type        = string
  default     = null
}

variable "target_resource_fqdn" {
  description = "Private FQDN of the target resource. Applicable for PORT_FORWARDING sessions."
  type        = string
  default     = null
}

variable "target_resource_port" {
  description = "Target port used by the bastion session."
  type        = number
  default     = 22
}

variable "target_resource_operating_system_user_name" {
  description = "Operating system username used by MANAGED_SSH sessions."
  type        = string
  default     = "opc"
}

variable "defined_tags" {
  description = "Defined tags applied to bastion resources."
  type        = map(string)
  default     = {}
}

variable "freeform_tags" {
  description = "Freeform tags applied to bastion resources."
  type        = map(string)
  default     = {}
}
