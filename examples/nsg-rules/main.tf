module "naming" {
  source  = "app.terraform.io/aztfmods/naming/azure"
  version = "~> 1.0"

  suffix = ["demo", "dev"]
}

module "groups" {
  source  = "app.terraform.io/aztfmods/rg/azure"
  version = "~> 2.0"

  config = {
    demo = {
      name     = module.naming.resource_group.name_unique
      location = "westeurope"
    }
  }
}

module "network" {
  source  = "app.terraform.io/aztfmods/vnet/azure"
  version = "~> 1.0"

  naming = local.naming

  config = {
    name                = module.naming.virtual_network.name
    location            = module.groups.config.demo.location
    resource_group_name = module.groups.config.demo.name
    address_space       = ["10.18.0.0/16"]

    subnets = {
      sn1 = {
        address_prefixes = ["10.18.1.0/24"]
        shared = {
          network_security_group = "shd"
        }
      },
      sn2 = {
        address_prefixes = ["10.18.2.0/24"]
        shared = {
          network_security_group = "shd"
        }
      },
      sn3 = {
        address_prefixes = ["10.18.3.0/24"]
        network_security_group = {
          rules = {
            myhttps = {
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
