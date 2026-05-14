module "vcn" {
  source = "git::https://github.com/mlinxfeld/terraform-oci-fk-vcn.git"

  compartment_ocid = var.compartment_ocid
  name             = "fk-private-lb-bastion-vcn"
  vcn_cidr_blocks  = ["10.60.0.0/16"]

  create_internet_gateway = true
  create_nat_gateway      = true
  create_service_gateway  = true

  route_tables = {
    public = {
      route_rules = [
        {
          destination        = "0.0.0.0/0"
          destination_type   = "CIDR_BLOCK"
          network_entity_key = "internet_gateway"
        }
      ]
    }
    private = {
      route_rules = [
        {
          destination        = "0.0.0.0/0"
          destination_type   = "CIDR_BLOCK"
          network_entity_key = "nat_gateway"
        },
        {
          destination        = "all-services"
          destination_type   = "SERVICE_CIDR_BLOCK"
          network_entity_key = "service_gateway"
        }
      ]
    }
  }

  security_lists = {
    bastion = {
      egress_rules = [
        {
          protocol    = "all"
          destination = "0.0.0.0/0"
        }
      ]
    }
    private_lb = {
      ingress_rules = [
        {
          protocol = "6"
          source   = "10.60.10.0/24"
          tcp_options = {
            min = 80
            max = 80
          }
        }
      ]
      egress_rules = [
        {
          protocol    = "all"
          destination = "0.0.0.0/0"
        }
      ]
    }
    private_app = {
      ingress_rules = [
        {
          protocol = "6"
          source   = "10.60.20.0/24"
          tcp_options = {
            min = 80
            max = 80
          }
        }
      ]
      egress_rules = [
        {
          protocol    = "all"
          destination = "0.0.0.0/0"
        }
      ]
    }
  }

  subnets = {
    bastion = {
      cidr_block                 = "10.60.10.0/24"
      route_table_key            = "public"
      security_list_keys         = ["bastion"]
      prohibit_public_ip_on_vnic = true
    }
    private_lb = {
      cidr_block                 = "10.60.20.0/24"
      route_table_key            = "private"
      security_list_keys         = ["private_lb"]
      prohibit_internet_ingress  = true
      prohibit_public_ip_on_vnic = true
    }
    private_app = {
      cidr_block                 = "10.60.30.0/24"
      route_table_key            = "private"
      security_list_keys         = ["private_app"]
      prohibit_internet_ingress  = true
      prohibit_public_ip_on_vnic = true
    }
  }
}
