variable "location" {
  description = "default azure region to be used."
  type        = string
  default     = null
}

variable "resource_group_name" {
  description = "default resource group to be used."
  type        = string
  default     = null
}

variable "tags" {
  description = "tags to be added to the resources"
  type        = map(string)
  default     = {}
}

variable "naming" {
  description = "contains naming convention"
  type        = map(string)
  default     = {}
}

variable "config" {
  description = "Contains virtual network configuration"
  type = object({
    name                    = string
    resource_group_name     = optional(string)
    location                = optional(string)
    address_space           = list(string)
    tags                    = optional(map(string))
    edge_zone               = optional(string)
    bgp_community           = optional(string)
    flow_timeout_in_minutes = optional(number)
    dns_servers             = optional(list(string), [])
    encryption = optional(object({
      enforcement = optional(string, "AllowUnencrypted")
    }))
    subnets = optional(map(object({
      name                                          = optional(string)
      cidr                                          = list(string)
      endpoints                                     = optional(list(string), [])
      private_link_service_network_policies_enabled = optional(bool, false)
      private_endpoint_network_policies             = optional(string, "Disabled")
      default_outbound_access_enabled               = optional(bool)
      service_endpoint_policy_ids                   = optional(list(string))
      delegations = optional(map(object({
        name    = string
        actions = optional(list(string), [])
      })))
      network_security_group = optional(object({
        name = optional(string)
        tags = optional(map(string))
        rules = optional(map(object({
          name                         = string
          priority                     = number
          direction                    = string
          access                       = string
          protocol                     = string
          description                  = optional(string)
          source_port_range            = optional(string)
          source_port_ranges           = optional(list(string))
          destination_port_range       = optional(string)
          destination_port_ranges      = optional(list(string))
          source_address_prefix        = optional(string)
          source_address_prefixes      = optional(list(string))
          destination_address_prefix   = optional(string)
          destination_address_prefixes = optional(list(string))
        })))
      }))
      route_table = optional(object({
        name                          = optional(string)
        bgp_route_propagation_enabled = optional(bool, true)
        tags                          = optional(map(string))
        routes = optional(map(object({
          address_prefix         = string
          next_hop_type          = string
          next_hop_in_ip_address = optional(string)
        })))
      }))
      shared = optional(object({
        route_table            = optional(string)
        network_security_group = optional(string)
      }), {})
    })), {})
    network_security_groups = optional(map(object({
      name = optional(string)
      tags = optional(map(string))
      rules = optional(map(object({
        name                         = string
        priority                     = number
        direction                    = string
        access                       = string
        protocol                     = string
        source_port_range            = optional(string)
        source_port_ranges           = optional(list(string))
        destination_port_range       = optional(string)
        destination_port_ranges      = optional(list(string))
        source_address_prefix        = optional(string)
        source_address_prefixes      = optional(list(string))
        destination_address_prefix   = optional(string)
        destination_address_prefixes = optional(list(string))
      })))
    })), {})
    route_tables = optional(map(object({
      name                          = optional(string)
      bgp_route_propagation_enabled = optional(bool, true)
      tags                          = optional(map(string))
      routes = optional(map(object({
        address_prefix         = string
        next_hop_type          = string
        next_hop_in_ip_address = optional(string)
      })))
    })), {})
  })
  validation {
    condition     = var.config.location != null || var.location != null
    error_message = "location must be provided either in the config object or as a separate variable."
  }
  validation {
    condition     = var.config.resource_group_name != null || var.resource_group_name != null
    error_message = "resource group name must be provided either in the config object or as a separate variable."
  }
  validation {
    condition = alltrue([
      for subnet in keys(var.config.subnets) : (
        var.config.subnets[subnet].shared.network_security_group == null ||
        try(contains(keys(var.config.network_security_groups), var.config.subnets[subnet].shared.network_security_group), false)
      )
    ])
    error_message = "One or more subnets reference a shared network_security_group that does not exist in network_security_groups."
  }
  validation {
    condition = alltrue([
      for subnet in keys(var.config.subnets) : (
        var.config.subnets[subnet].shared.route_table == null ||
        try(contains(keys(var.config.route_tables), var.config.subnets[subnet].shared.route_table), false)
      )
    ])
    error_message = "One or more subnets reference a shared route_table that does not exist in route_tables."
  }
}
