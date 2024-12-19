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
          route_table = "shd"
        }
      },
      sn2 = {
        address_prefixes = ["10.18.2.0/24"]
        shared = {
          route_table = "shd"
        }
      },
      sn3 = {
        address_prefixes = ["10.18.3.0/24"]
        route_table = {
          routes = {
            rt3 = {
              address_prefix = "storage"
              next_hop_type  = "Internet"
            }
          }
        }
      }
    }
    route_tables = {
      shd = {
        routes = {
          rt1 = {
            address_prefix = "0.0.0.0/0"
            next_hop_type  = "Internet"
          }
        }
      }
    }
  }
}
