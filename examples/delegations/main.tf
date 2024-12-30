module "naming" {
  source  = "app.terraform.io/azyphon/naming/azure"
  version = "~> 1.0"

  suffix = ["demo", "dev"]
}

module "groups" {
  source  = "app.terraform.io/azyphon/rg/azure"
  version = "~> 2.0"

  config = {
    demo = {
      name     = module.naming.resource_group.name_unique
      location = "westeurope"
    }
  }
}

module "network" {
  source  = "app.terraform.io/azyphon/vnet/azure"
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
        delegations = {
          sql = {
            name = "Microsoft.Sql/managedInstances"
            actions = [
              "Microsoft.Network/virtualNetworks/subnets/join/action",
              "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
              "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action",
            ]
          }
        }
      }
      sn2 = {
        address_prefixes = ["10.18.2.0/24"]
        delegations = {
          web = {
            name = "Microsoft.Web/serverFarms"
          }
        }
      }
    }
  }
}
