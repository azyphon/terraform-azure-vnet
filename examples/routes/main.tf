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
        cidr = ["10.18.1.0/24"]
        shared = {
          route_table = "shd"
        }
      },
      sn2 = {
        cidr = ["10.18.2.0/24"]
        shared = {
          route_table = "shd"
        }
      },
      sn3 = {
        cidr = ["10.18.3.0/24"]
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
