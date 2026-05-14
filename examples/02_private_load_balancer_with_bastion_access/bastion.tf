module "bastion" {
  source = "../.."

  name                         = "fk-bastion"
  compartment_ocid             = var.compartment_ocid
  target_subnet_id             = module.vcn.subnet_ids["bastion"]
  client_cidr_block_allow_list = [var.operator_client_cidr]

  create_session                     = true
  session_name                       = "fk-private-lb-http-session"
  session_type                       = "PORT_FORWARDING"
  ssh_public_key                     = tls_private_key.public_private_key_pair.public_key_openssh
  target_resource_private_ip_address = module.loadbalancer.load_balancer_private_ips[0]
  target_resource_port               = 80
}
