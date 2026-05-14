output "load_balancer_id" {
  value = module.loadbalancer.load_balancer_id
}

output "load_balancer_private_ips" {
  value = module.loadbalancer.load_balancer_private_ips
}

output "backend_private_ips" {
  value = [for instance in module.compute : instance.instance_private_ip]
}

output "bastion_id" {
  value = module.bastion.bastion_id
}

output "session_id" {
  value = module.bastion.session_id
}

output "session_ssh_command" {
  value = module.bastion.session_ssh_command
}

output "ssh_private_key_pem" {
  description = "Private key for OCI Bastion port-forwarding access. Keep it secret."
  value       = tls_private_key.public_private_key_pair.private_key_pem
  sensitive   = true
}

output "ssh_public_key_openssh" {
  description = "Generated public key used by the OCI Bastion session."
  value       = tls_private_key.public_private_key_pair.public_key_openssh
}
