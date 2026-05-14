module "compute" {
  source = "git::https://github.com/mlinxfeld/terraform-oci-fk-compute.git"

  name             = "fk-private-vm"
  tenancy_ocid     = var.tenancy_ocid
  compartment_ocid = var.compartment_ocid
  subnet_id        = module.vcn.subnet_ids["private_vm"]

  deployment_mode          = "instance"
  shape                    = "VM.Standard.E4.Flex"
  operating_system_version = "9"
  shape_config = {
    ocpus         = 1
    memory_in_gbs = 8
  }

  ssh_authorized_keys = [tls_private_key.public_private_key_pair.public_key_openssh]
  assign_public_ip    = false
}
