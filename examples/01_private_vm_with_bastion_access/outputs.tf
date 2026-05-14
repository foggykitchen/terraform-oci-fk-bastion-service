output "instance_id" {
  value = module.compute.instance_id
}

output "instance_private_ip" {
  value = module.compute.instance_private_ip
}

output "bastion_id" {
  value = module.bastion.bastion_id
}

output "bastion_private_endpoint_ip_address" {
  value = module.bastion.bastion_private_endpoint_ip_address
}

output "session_id" {
  value = module.bastion.session_id
}

output "session_ssh_command" {
  value = module.bastion.session_ssh_command
}

output "ssh_private_key_pem" {
  description = "Private key for SSH access to the private VM through OCI Bastion. Keep it secret."
  value       = tls_private_key.public_private_key_pair.private_key_pem
  sensitive   = true
}

output "ssh_public_key_openssh" {
  description = "Generated public key injected into the private VM and Bastion session."
  value       = tls_private_key.public_private_key_pair.public_key_openssh
}
