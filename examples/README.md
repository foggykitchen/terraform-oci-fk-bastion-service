# OCI Bastion Service with Terraform/OpenTofu - Training Examples

This directory contains runnable examples for the **terraform-oci-fk-bastion-service** module.
The examples focus on practical OCI Bastion Service deployment patterns, from private SSH access to private HTTP access through port forwarding.

These examples are part of the **[FoggyKitchen.com training ecosystem](https://foggykitchen.com/courses-2/)** and are used across OCI and multicloud courses covering networking, compute, secure access, and architecture fundamentals.

---

## Published Examples

| Example | Title | Key Topics |
|:-------:|:------|:-----------|
| 01 | **Private VM with Bastion Access** | private compute instance, managed SSH session, NAT Gateway egress, generated SSH key pair, `terraform-oci-fk-vcn` and `terraform-oci-fk-compute` integration |
| 02 | **Private Load Balancer with Bastion Access** | private load balancer, private backend instances, port forwarding session, generated SSH key pair, `terraform-oci-fk-vcn`, `terraform-oci-fk-compute`, and `terraform-oci-fk-loadbalancer` integration |

---

## How to Use

The example directory contains:
- Terraform/OpenTofu configuration (`.tf`)
- A focused `README.md` explaining the goal of the example
- A minimal, runnable architecture

To run the private VM example:

```bash
cd examples/01_private_vm_with_bastion_access
tofu init
tofu plan
tofu apply
```

To run the private load balancer example:

```bash
cd examples/02_private_load_balancer_with_bastion_access
tofu init
tofu plan
tofu apply
```

---

## Design Principles

- One example = one architectural goal
- No unused or placeholder resources
- Clear separation of concerns between networking, compute, load balancing, and secure access
- Examples designed to integrate with other modules such as VCN, Compute, and Load Balancer

---

## Related Resources

- [FoggyKitchen OCI Bastion Service Module (terraform-oci-fk-bastion-service)](../)
- [FoggyKitchen OCI VCN Module (terraform-oci-fk-vcn)](https://github.com/mlinxfeld/terraform-oci-fk-vcn)
- [FoggyKitchen OCI Compute Module (terraform-oci-fk-compute)](https://github.com/mlinxfeld/terraform-oci-fk-compute)
- [FoggyKitchen OCI Load Balancer Module (terraform-oci-fk-loadbalancer)](https://github.com/mlinxfeld/terraform-oci-fk-loadbalancer)
- [FoggyKitchen Azure Bastion Module (terraform-az-fk-bastion)](https://github.com/mlinxfeld/terraform-az-fk-bastion)

---

## License

Licensed under the **Universal Permissive License (UPL), Version 1.0**.
See [LICENSE](../LICENSE) for details.

---

© 2026 FoggyKitchen.com - Cloud. Code. Clarity.
