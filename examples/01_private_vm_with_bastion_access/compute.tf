module "compute" {
  source = "git::https://github.com/foggykitchen/terraform-oci-fk-compute.git?ref=v0.2.0"

  name             = "fk-private-vm"
  tenancy_ocid     = var.tenancy_ocid
  compartment_ocid = var.compartment_ocid
  subnet_id        = module.vcn.subnet_ids["fk-private-vm-subnet"]

  deployment_mode          = "instance"
  shape                    = "VM.Standard.E4.Flex"
  operating_system_version = "9"
  shape_config = {
    ocpus         = 1
    memory_in_gbs = 8
  }

  ssh_authorized_keys = [tls_private_key.public_private_key_pair.public_key_openssh]
  assign_public_ip    = false

  agent_config = {
    is_management_disabled = false
    is_monitoring_disabled = false
    plugins_config = [
      {
        desired_state = "ENABLED"
        name          = "Bastion"
      }
    ]
  }
}

resource "time_sleep" "wait_for_bastion_plugin" {
  depends_on      = [module.compute]
  create_duration = var.bastion_plugin_wait_duration
}
