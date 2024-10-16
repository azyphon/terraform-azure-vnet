module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.1"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 2.0"

  groups = {
    demo = {
      name     = module.naming.resource_group.name_unique
      location = "westeurope"
    }
  }
}

module "network" {
  #source  = "cloudnationhq/vnet/azure"
  #version = "~> 6.0"
  source = "../../"

  naming = local.naming

  config = {
    name                = module.naming.virtual_network.name
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name
    address_space       = ["10.18.0.0/16"]

    subnets = {
      sn1 = {
        cidr                          = ["10.18.1.0/24"]
        network_security_group_shared = "shd"
      },
      sn2 = {
        cidr                          = ["10.18.2.0/24"]
        network_security_group_shared = "shd"
      },
      sn3 = {
        cidr = ["10.18.3.0/24"]
        network_security_group = {
          rules = {
            myhttps = {
              name                       = "myhttps"
              priority                   = 100
              direction                  = "Inbound"
              access                     = "Allow"
              protocol                   = "Tcp"
              source_port_range          = "*"
              destination_port_range     = "443"
              source_address_prefix      = "10.151.1.0/24"
              destination_address_prefix = "*"
            }
          }
        }
      }
    }
    network_security_groups = {
      shd = {
        rules = {
          allow_http = {
            name                       = "allow_http"
            priority                   = 100
            direction                  = "Inbound"
            access                     = "Allow"
            protocol                   = "Tcp"
            source_port_range          = "*"
            destination_port_range     = "80"
            source_address_prefix      = "*"
            destination_address_prefix = "*"
          }
        }
      }
    }
  }
}
