locals {
  session_name_effective = coalesce(var.session_name, "${var.name}-session")
}

resource "oci_bastion_bastion" "this" {
  bastion_type                 = var.bastion_type
  compartment_id               = var.compartment_ocid
  target_subnet_id             = var.target_subnet_id
  client_cidr_block_allow_list = var.client_cidr_block_allow_list
  name                         = var.name
  max_session_ttl_in_seconds   = var.max_session_ttl_in_seconds

  defined_tags  = var.defined_tags
  freeform_tags = var.freeform_tags
}

resource "oci_bastion_session" "this" {
  count = var.create_session ? 1 : 0

  bastion_id             = oci_bastion_bastion.this.id
  display_name           = local.session_name_effective
  session_ttl_in_seconds = var.session_ttl_in_seconds

  key_details {
    public_key_content = var.ssh_public_key
  }

  target_resource_details {
    session_type                               = var.session_type
    target_resource_id                         = var.target_resource_id
    target_resource_private_ip_address         = var.target_resource_private_ip_address
    target_resource_fqdn                       = var.target_resource_fqdn
    target_resource_operating_system_user_name = var.target_resource_operating_system_user_name
    target_resource_port                       = var.target_resource_port
  }

  lifecycle {
    precondition {
      condition     = var.ssh_public_key != null && length(trimspace(var.ssh_public_key)) > 0
      error_message = "ssh_public_key must be provided when create_session is true."
    }

    precondition {
      condition     = var.session_ttl_in_seconds <= var.max_session_ttl_in_seconds
      error_message = "session_ttl_in_seconds cannot exceed max_session_ttl_in_seconds."
    }

    precondition {
      condition = (
        var.session_type == "MANAGED_SSH" &&
        var.target_resource_id != null &&
        var.target_resource_private_ip_address != null
        ) || (
        contains(["PORT_FORWARDING", "DYNAMIC_PORT_FORWARDING"], var.session_type) &&
        (
          var.target_resource_private_ip_address != null ||
          var.target_resource_fqdn != null
        )
      )
      error_message = "MANAGED_SSH requires target_resource_id and target_resource_private_ip_address. PORT_FORWARDING and DYNAMIC_PORT_FORWARDING require target_resource_private_ip_address or target_resource_fqdn."
    }
  }
}
