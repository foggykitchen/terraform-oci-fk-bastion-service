output "bastion_id" {
  description = "OCI Bastion OCID."
  value       = oci_bastion_bastion.this.id
}

output "bastion_name" {
  description = "OCI Bastion display name."
  value       = oci_bastion_bastion.this.name
}

output "bastion_type" {
  description = "OCI Bastion type."
  value       = oci_bastion_bastion.this.bastion_type
}

output "bastion_private_endpoint_ip_address" {
  description = "Private endpoint IP address assigned to the bastion inside the target subnet."
  value       = try(oci_bastion_bastion.this.private_endpoint_ip_address, null)
}

output "bastion_target_subnet_id" {
  description = "Target subnet OCID used by the bastion."
  value       = oci_bastion_bastion.this.target_subnet_id
}

output "bastion_target_vcn_id" {
  description = "Target VCN OCID inferred by the bastion."
  value       = try(oci_bastion_bastion.this.target_vcn_id, null)
}

output "bastion_static_jump_host_ip_addresses" {
  description = "Static jump host IP addresses published by OCI Bastion."
  value       = try(oci_bastion_bastion.this.static_jump_host_ip_addresses, [])
}

output "session_id" {
  description = "Created bastion session OCID, if any."
  value       = try(oci_bastion_session.this[0].id, null)
}

output "session_name" {
  description = "Created bastion session display name, if any."
  value       = try(oci_bastion_session.this[0].display_name, null)
}

output "session_state" {
  description = "Lifecycle state of the created bastion session, if any."
  value       = try(oci_bastion_session.this[0].state, null)
}

output "session_ssh_metadata" {
  description = "SSH metadata map returned by OCI for the created session."
  value       = try(oci_bastion_session.this[0].ssh_metadata, null)
}

output "session_ssh_command" {
  description = "Convenience output with the generated SSH command, if OCI returns it."
  value       = try(oci_bastion_session.this[0].ssh_metadata["command"], null)
}
