# Example 02: Private Load Balancer with OCI Bastion Service Access

In this example, we deploy a **private Oracle Cloud Infrastructure (OCI) Load Balancer** fronting multiple **private compute instances** and provide operator access to the internal HTTP endpoint **through OCI Bastion Service port forwarding**.

This example is intentionally focused on the **private application access path**:
- the backend instances have **no public IPs**
- the load balancer is **private**
- operator access is **time-limited** and tunneled through Bastion
- the SSH key pair is generated automatically with the **TLS provider**

---

## Architecture Overview

This deployment creates:
- a dedicated **VCN** and three subnets using `terraform-oci-fk-vcn`
- multiple **private backend compute instances** using `terraform-oci-fk-compute`
- one **private OCI Load Balancer** using `terraform-oci-fk-loadbalancer`
- one **OCI Bastion** and one **PORT_FORWARDING session** using `terraform-oci-fk-bastion-service`

Key subnets:
- `bastion` for the OCI Bastion private endpoint
- `private_lb` for the private load balancer frontend
- `private_app` for backend instances

This example shows how Bastion Service can be used not only for SSH access,
but also for controlled access to private application endpoints.

---

## Deployment Steps

Initialize and apply the Terraform/OpenTofu configuration:

```bash
cp terraform.tfvars.example terraform.tfvars
tofu init
tofu plan
tofu apply
```

If you prefer Terraform:

```bash
terraform init
terraform plan
terraform apply
```

After a successful deployment, Terraform/OpenTofu will output:
- the private load balancer ID
- the private load balancer IP address
- the backend private IP addresses
- the Bastion ID
- the Bastion session ID
- the generated SSH command
- the generated private SSH key as a sensitive output

---

## Access Flow

After deployment, export the generated private key:

```bash
tofu output -raw ssh_private_key_pem > id_rsa
chmod 600 id_rsa
```

Then inspect the generated Bastion command:

```bash
tofu output -raw session_ssh_command
```

Use the returned command to create the OCI Bastion port-forwarding tunnel, then test the private HTTP service locally. A typical flow looks like this:

```bash
ssh -i ./id_rsa -N -L 8080:10.60.20.x:80 <oci-generated-session-endpoint>
curl http://127.0.0.1:8080
```

Expected result:
- HTTP response served by one of the private backend instances
- no public IP on the load balancer
- access limited to the configured Bastion session TTL

---

## Important Session Lifecycle Note

OCI Bastion sessions are temporary. Once the configured TTL expires, the session becomes inactive and may no longer be removable through `terraform destroy`.

For this reason:
- test the example soon after `apply`
- run `tofu destroy` before the Bastion session expires
- if the session is already inactive, you may need to remove it manually in OCI before retrying destroy

---

## Summary

This example demonstrates:
- how to deploy a **private OCI Load Balancer**
- how to expose a private HTTP service through **OCI Bastion Service port forwarding**
- how to compose the Bastion module with `terraform-oci-fk-vcn`, `terraform-oci-fk-compute`, and `terraform-oci-fk-loadbalancer`
- how to generate an SSH key pair automatically for demo and testing purposes

---

## Cleanup

To remove all resources created by this example:

```bash
tofu destroy
```

Or with Terraform:

```bash
terraform destroy
```

---

## Learn More

Visit [FoggyKitchen.com](https://foggykitchen.com/) for OCI, multicloud, and Terraform/OpenTofu learning resources.

---

## License

Licensed under the **Universal Permissive License (UPL), Version 1.0**.
See [LICENSE](../../LICENSE) for more details.
