# OCI Bastion Service with Terraform/OpenTofu - Training Examples

This directory contains runnable examples for the **terraform-oci-fk-bastion-service** module.
The examples focus on practical OCI Bastion Service deployment patterns for private workload access.

These examples are part of the **[FoggyKitchen.com training ecosystem](https://foggykitchen.com/courses-2/)** and are used across OCI and multicloud courses covering networking, compute, secure access, and architecture fundamentals.

---

## Published Examples

| Example | Title | Key Topics |
|:-------:|:------|:-----------|
| 01 | **Private VM with Bastion Access** | private compute instance, managed SSH session, NAT Gateway egress, generated SSH key pair, `terraform-oci-fk-vcn` and `terraform-oci-fk-compute` integration |

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

---

## Design Principles

- One example = one architectural goal
- No unused or placeholder resources
- Clear separation of concerns between networking, compute, load balancing, and secure access
- Examples designed to integrate with other modules such as VCN and Compute

---

## Related Resources

- [FoggyKitchen OCI Bastion Service Module (terraform-oci-fk-bastion-service)](../)
- [FoggyKitchen OCI VCN Module (terraform-oci-fk-vcn)](https://github.com/foggykitchen/terraform-oci-fk-vcn)
- [FoggyKitchen OCI Compute Module (terraform-oci-fk-compute)](https://github.com/foggykitchen/terraform-oci-fk-compute)
- [FoggyKitchen Azure Bastion Module (terraform-az-fk-bastion)](https://github.com/mlinxfeld/terraform-az-fk-bastion)

---

## License

Licensed under the **Universal Permissive License (UPL), Version 1.0**.
See [LICENSE](../LICENSE) for details.

---

© 2026 [FoggyKitchen.com](https://foggykitchen.com) - Cloud. Code. Clarity.
