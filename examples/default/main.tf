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
  #source  = "app.terraform.io/aztfmods/rg/azure"
  #version = "~> 1.0"

  source = "../../"

  naming = local.naming

  config = {
    name                = module.naming.virtual_network.name
    location            = module.groups.config.demo.location
    resource_group_name = module.groups.config.demo.name
    address_space       = ["10.18.0.0/16"]

    subnets = {
      sn1 = {
        cidr = ["10.18.1.0/24"]
        #network_security_group = {
          #rules = {
            #myhttps = {
              #name                       = "myhttps"
              #priority                   = 100
              #direction                  = "Inbound"
              #access                     = "Allow"
              #protocol                   = "Tcp"
              #source_port_range          = "*"
              #destination_port_range     = "443"
              #source_address_prefix      = "10.151.1.0/24"
              #destination_address_prefix = "*"
            #}
            #mysql = {
              #name                       = "mysql"
              #priority                   = 200
              #direction                  = "Inbound"
              #access                     = "Allow"
              #protocol                   = "Tcp"
              #source_port_range          = "*"
              #destination_port_ranges    = ["3306", "3307"]
              #source_address_prefixes    = ["10.0.0.0/24", "11.0.0.0/24"]
              #destination_address_prefix = "*"
            #}
          #}
        #}
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
        cidr = ["10.18.2.0/24"]
        delegations = {
          web = {
            name = "Microsoft.Web/serverFarms"
          }
        }
      }
    }
  }
}
