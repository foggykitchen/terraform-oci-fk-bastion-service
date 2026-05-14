module "bastion" {
  source = "../.."

  name                         = "fk-bastion"
  compartment_ocid             = var.compartment_ocid
  target_subnet_id             = module.vcn.subnet_ids["bastion"]
  client_cidr_block_allow_list = [var.operator_client_cidr]

  create_session                             = true
  session_name                               = "fk-private-vm-session"
  session_type                               = "MANAGED_SSH"
  ssh_public_key                             = tls_private_key.public_private_key_pair.public_key_openssh
  target_resource_id                         = module.compute.instance_id
  target_resource_private_ip_address         = module.compute.instance_private_ip
  target_resource_port                       = 22
  target_resource_operating_system_user_name = "opc"
}
