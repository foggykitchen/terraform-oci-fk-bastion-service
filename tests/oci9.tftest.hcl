# Synthetic fixtures only. Every run is plan-only; no tenancy credentials are used.
mock_provider "oci" {
  mock_resource "oci_bastion_bastion" {
    defaults = { "id" = "MOCK_OCID_BASTION", "lifecycle_details" = "mock-value", "max_sessions_allowed" = 1, "private_endpoint_ip_address" = "10.0.0.10", "state" = "AVAILABLE", "system_tags" = {}, "target_vcn_id" = "MOCK_OCID_MOCK", "time_created" = "mock-value", "time_updated" = "mock-value" }
  }
  mock_resource "oci_bastion_session" {
    defaults = { "bastion_name" = "mock-value", "bastion_public_host_key_info" = "mock-value", "bastion_user_name" = "mock-value", "id" = "MOCK_OCID_SESSION", "lifecycle_details" = "mock-value", "ssh_metadata" = {}, "state" = "AVAILABLE", "time_created" = "mock-value", "time_updated" = "mock-value" }
  }
}
variables {
  name                         = "compatibility"
  compartment_ocid             = "MOCK_OCID_COMPARTMENT"
  target_subnet_id             = "MOCK_OCID_SUBNET"
  client_cidr_block_allow_list = ["203.0.113.10/32"]
}

run "oci9_plan" {
  command = plan
}
