# terraform-oci-fk-bastion-service

This repository contains a reusable **Terraform/OpenTofu module** and progressive examples for deploying **Oracle Cloud Infrastructure (OCI) Bastion Service** as a secure, time-limited access layer for private OCI workloads.

It is part of the **[FoggyKitchen.com training ecosystem](https://foggykitchen.com/courses-2/)** and is designed to work cleanly with reusable infrastructure modules such as **`terraform-oci-fk-vcn`**, **`terraform-oci-fk-compute`**, and **`terraform-oci-fk-loadbalancer`**.

---

## Purpose

The goal of this module is to provide a **clean, composable, and educational reference implementation** for OCI Bastion Service:

- Focused on OCI-native secure access patterns
- Suitable for both **managed SSH** and **port-forwarding** workflows
- Designed for hands-on learning, module composition, and multicloud comparisons

This is **not** a full landing zone or a persistent jump-host solution. It is a **learning-first, architecture-aware module**.

---

## What the module does

The module creates:

- OCI Bastion
- Optional OCI Bastion session
- Explicit client CIDR allow list
- Configurable maximum session TTL
- Session definitions for `MANAGED_SSH`, `PORT_FORWARDING`, and `DYNAMIC_PORT_FORWARDING`

The module intentionally does **not** create:
- VCNs or subnets
- Compute instances
- Load Balancers
- IAM policies or user/group bindings
- Long-lived bastion VMs or jump-box hosts

Each of those concerns belongs in its own dedicated module or tenant-level access design.

---

## Known OCI Bastion Service Limitation

OCI Bastion sessions are **time-limited by design**. After the configured TTL expires, the session becomes inactive and may no longer be cleanly removable through `terraform destroy`.

In practice, this means:
- Bastion resources can outlive a failed or delayed destroy workflow
- expired sessions may need to be removed manually from OCI
- examples in this repository are best destroyed **before** the Bastion session TTL expires

This behavior comes from the OCI Bastion Service lifecycle model rather than from the Terraform module itself.

---

## Repository Structure

```bash
terraform-oci-fk-bastion-service/
├── examples/
│   ├── 01_private_vm_with_bastion_access/
│   └── README.md
├── main.tf
├── inputs.tf
├── outputs.tf
├── versions.tf
├── LICENSE
└── README.md
```

The included example is runnable and demonstrates a focused **secure-access pattern** for private SSH access to a single VM.

---

## Example Usage

### Bastion only

```hcl
module "bastion" {
  source = "git::https://github.com/foggykitchen/terraform-oci-fk-bastion-service.git?ref=v1.0.0"

  name                         = "fk-bastion"
  compartment_ocid             = var.compartment_ocid
  target_subnet_id             = module.vcn.subnet_ids["bastion"]
  client_cidr_block_allow_list = ["203.0.113.10/32"]

  max_session_ttl_in_seconds = 10800
}
```

### Bastion with managed SSH session

```hcl
module "bastion" {
  source = "git::https://github.com/foggykitchen/terraform-oci-fk-bastion-service.git?ref=v1.0.0"

  name                         = "fk-bastion"
  compartment_ocid             = var.compartment_ocid
  target_subnet_id             = module.vcn.subnet_ids["bastion"]
  client_cidr_block_allow_list = ["203.0.113.10/32"]

  create_session                             = true
  ssh_public_key                             = file("~/.ssh/id_rsa.pub")
  session_type                               = "MANAGED_SSH"
  target_resource_id                         = module.compute.instance_id
  target_resource_private_ip_address         = module.compute.instance_private_ip
  target_resource_operating_system_user_name = "opc"
  target_resource_port                       = 22
}
```

### Bastion with port forwarding

```hcl
module "bastion" {
  source = "git::https://github.com/foggykitchen/terraform-oci-fk-bastion-service.git?ref=v1.0.0"

  name                         = "fk-bastion"
  compartment_ocid             = var.compartment_ocid
  target_subnet_id             = module.vcn.subnet_ids["bastion"]
  client_cidr_block_allow_list = ["203.0.113.10/32"]

  create_session                     = true
  ssh_public_key                     = file("~/.ssh/id_rsa.pub")
  session_type                       = "PORT_FORWARDING"
  target_resource_private_ip_address = module.loadbalancer.load_balancer_private_ips[0]
  target_resource_port               = 80
}
```

---

## Module Inputs

### Core inputs

| Variable | Type | Required | Description |
|--------|------|----------|-------------|
| `name` | `string` | ✅ | Bastion display name |
| `compartment_ocid` | `string` | ✅ | OCI compartment OCID |
| `target_subnet_id` | `string` | ✅ | Subnet OCID used by the Bastion private endpoint |
| `client_cidr_block_allow_list` | `list(string)` | ✅ | Allowed client CIDRs for Bastion access |
| `bastion_type` | `string` | ❌ | OCI Bastion type, `STANDARD` by default |
| `max_session_ttl_in_seconds` | `number` | ❌ | Maximum allowed session lifetime on the Bastion |
| `defined_tags` | `map(string)` | ❌ | Defined tags |
| `freeform_tags` | `map(string)` | ❌ | Freeform tags |

### Session inputs

| Variable | Type | Required | Description |
|--------|------|----------|-------------|
| `create_session` | `bool` | ❌ | Whether to create a session together with the Bastion |
| `session_name` | `string` | ❌ | Optional session display name override |
| `session_type` | `string` | ❌ | `MANAGED_SSH`, `PORT_FORWARDING`, or `DYNAMIC_PORT_FORWARDING` |
| `session_ttl_in_seconds` | `number` | ❌ | Requested session lifetime |
| `ssh_public_key` | `string` | ❌ | OpenSSH public key used by the session |
| `target_resource_id` | `string` | ❌ | Usually required for `MANAGED_SSH` |
| `target_resource_private_ip_address` | `string` | ❌ | Private IP address of the target resource |
| `target_resource_fqdn` | `string` | ❌ | Optional private FQDN for `PORT_FORWARDING` |
| `target_resource_port` | `number` | ❌ | Target port for the session |
| `target_resource_operating_system_user_name` | `string` | ❌ | OS username used by `MANAGED_SSH` sessions |

---

## Outputs

| Output | Description |
|------|-------------|
| `bastion_id` | OCI Bastion OCID |
| `bastion_name` | OCI Bastion display name |
| `bastion_type` | OCI Bastion type |
| `bastion_private_endpoint_ip_address` | Bastion private endpoint IP address |
| `bastion_target_subnet_id` | Target subnet OCID |
| `bastion_target_vcn_id` | Target VCN OCID |
| `bastion_static_jump_host_ip_addresses` | Static jump host IP addresses published by OCI |
| `session_id` | OCI Bastion session OCID, if created |
| `session_name` | OCI Bastion session display name, if created |
| `session_state` | OCI Bastion session lifecycle state |
| `session_ssh_metadata` | SSH metadata returned by OCI |
| `session_ssh_command` | Generated SSH command when OCI returns it |

---

## Examples Overview

| Example | Description |
|-------|-------------|
| `01_private_vm_with_bastion_access` | Private OCI compute instance reachable only through OCI Bastion Service managed SSH |

See [`examples/`](examples) for details.

---

## Design Philosophy

- Explicit access patterns over implicit defaults
- Small modules over monoliths
- Managed secure access over self-managed jump hosts
- Optimized for **learning, reuse, and composition**

This makes the module ideal for:
- private compute access
- internal application testing
- training material
- multicloud architecture comparisons

---

## Related Resources

- [FoggyKitchen OCI Bastion Service Examples](examples)
- [FoggyKitchen OCI VCN Module (terraform-oci-fk-vcn)](https://github.com/foggykitchen/terraform-oci-fk-vcn)
- [FoggyKitchen OCI Compute Module (terraform-oci-fk-compute)](https://github.com/foggykitchen/terraform-oci-fk-compute)
- [FoggyKitchen OCI Load Balancer Module (terraform-oci-fk-loadbalancer)](https://github.com/foggykitchen/terraform-oci-fk-loadbalancer)
- [FoggyKitchen Azure Bastion Module (terraform-az-fk-bastion)](https://github.com/mlinxfeld/terraform-az-fk-bastion)

---

## License

Licensed under the **Universal Permissive License (UPL), Version 1.0**.
See [LICENSE](LICENSE) for details.

---

©(https://foggykitchen.com) - Cloud. Code. Clarity.
