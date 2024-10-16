# virtual network
resource "azurerm_virtual_network" "vnet" {
  resource_group_name = coalesce(
    var.config.resource_group_name, var.resource_group_name
  )

  location = coalesce(
    var.config.location, var.location
  )


  name                    = var.config.name
  address_space           = var.config.address_space
  edge_zone               = var.config.edge_zone
  bgp_community           = var.config.bgp_community
  flow_timeout_in_minutes = var.config.flow_timeout_in_minutes

  dynamic "encryption" {
    for_each = var.config.encryption != null ? [var.config.encryption] : []
    content {
      enforcement = encryption.value.enforcement
    }
  }

  tags = try(
    var.config.tags, var.tags, {}
  )

  lifecycle {
    ignore_changes = [subnet, dns_servers]
  }
}

resource "azurerm_virtual_network_dns_servers" "dns" {
  for_each = length(lookup(var.config, "dns_servers", [])) > 0 ? { "default" = var.config.dns_servers } : {}

  virtual_network_id = azurerm_virtual_network.vnet.id
  dns_servers        = each.value
}

# subnets
resource "azurerm_subnet" "subnets" {
  for_each = lookup(
    var.config, "subnets", {}
  )

  name = coalesce(
    each.value.name, join("-", [var.naming.subnet, each.key])
  )

  resource_group_name = coalesce(
    var.config.resource_group_name, var.resource_group_name
  )

  virtual_network_name                          = azurerm_virtual_network.vnet.name
  address_prefixes                              = each.value.cidr
  service_endpoints                             = each.value.endpoints
  private_link_service_network_policies_enabled = each.value.private_link_service_network_policies_enabled
  private_endpoint_network_policies             = each.value.private_endpoint_network_policies
  service_endpoint_policy_ids                   = each.value.service_endpoint_policy_ids
  default_outbound_access_enabled               = each.value.default_outbound_access_enabled

  dynamic "delegation" {
    for_each = each.value.delegations != null ? each.value.delegations : {}

    content {
      name = delegation.key

      service_delegation {
        name    = delegation.value.name
        actions = delegation.value.actions
      }
    }
  }
}

# network security groups individual and shared
resource "azurerm_network_security_group" "nsg" {
  for_each = merge(
    var.config.network_security_groups, {
      for subnet_key, subnet in var.config.subnets : subnet_key => subnet.network_security_group
      if subnet.network_security_group != null
    }
  )

  name                = coalesce(lookup(each.value, "name", null), "${var.config.name}-${each.key}-nsg")
  resource_group_name = var.config.resource_group_name
  location            = var.config.location
  tags                = try(var.config.tags, var.tags, {})
}

# security rules individual and shared
resource "azurerm_network_security_rule" "rules" {
  for_each = merge({
    for pair in flatten([
      for nsg_key, nsg in lookup(var.config, "network_security_groups", {}) :
      can(nsg.rules) ? (
        nsg.rules != null ? [
          for rule_key, rule in nsg.rules : {
            key = "${nsg_key}_${rule_key}"
            value = {
              nsg_name  = azurerm_network_security_group.nsg[nsg_key].name
              rule_name = rule_key
              rule      = rule
            }
          }
        ] : []
      ) : []
    ]) : pair.key => pair.value
    }, {
    for pair in flatten([
      for subnet_key, subnet in var.config.subnets :
      can(subnet.network_security_group.rules) ? (
        subnet.network_security_group.rules != null ? [
          for rule_key, rule in subnet.network_security_group.rules : {
            key = "${subnet_key}_${rule_key}"
            value = {
              nsg_name  = azurerm_network_security_group.nsg[subnet_key].name
              rule_name = rule_key
              rule      = rule
            }
          }
        ] : []
      ) : []
    ]) : pair.key => pair.value
    }
  )

  name                         = each.value.rule_name
  priority                     = each.value.rule.priority
  direction                    = each.value.rule.direction
  access                       = each.value.rule.access
  protocol                     = each.value.rule.protocol
  source_port_range            = lookup(each.value.rule, "source_port_range", null)
  source_port_ranges           = lookup(each.value.rule, "source_port_ranges", null)
  destination_port_range       = lookup(each.value.rule, "destination_port_range", null)
  destination_port_ranges      = lookup(each.value.rule, "destination_port_ranges", null)
  source_address_prefix        = lookup(each.value.rule, "source_address_prefix", null)
  source_address_prefixes      = lookup(each.value.rule, "source_address_prefixes", null)
  destination_address_prefix   = lookup(each.value.rule, "destination_address_prefix", null)
  destination_address_prefixes = lookup(each.value.rule, "destination_address_prefixes", null)
  description                  = lookup(each.value.rule, "description", null)
  resource_group_name          = var.config.resource_group_name
  network_security_group_name  = each.value.nsg_name
}

# nsg associations
resource "azurerm_subnet_network_security_group_association" "nsg_as" {
  for_each = {
    for subnet_key, subnet in var.config.subnets : subnet_key => subnet
    if subnet.network_security_group_shared != null || subnet.network_security_group != null
  }

  subnet_id                 = azurerm_subnet.subnets[each.key].id
  network_security_group_id = each.value.network_security_group_shared != null ? azurerm_network_security_group.nsg[each.value.network_security_group_shared].id : azurerm_network_security_group.nsg[each.key].id
}

# Route tables (individual and shared)
resource "azurerm_route_table" "rt" {
  for_each = merge(
    var.config.route_tables,
    {
      for subnet_key, subnet in var.config.subnets : subnet_key => subnet.route_table
      if subnet.route_table != null
    }
  )

  name                          = coalesce(lookup(each.value, "name", null), "${var.config.name}-${each.key}-rt")
  resource_group_name           = var.config.resource_group_name
  location                      = var.config.location
  bgp_route_propagation_enabled = lookup(each.value, "bgp_route_propagation_enabled", true)
  tags                          = try(var.config.tags, var.tags, {})

  lifecycle {
    ignore_changes = [route]
  }
}

# Routes (for both shared and individual route tables)
resource "azurerm_route" "routes" {
  for_each = merge({
    for pair in flatten([
      for rt_key, rt in lookup(var.config, "route_tables", {}) :
      can(rt.routes) ? (
        rt.routes != null ? [
          for route_key, route in rt.routes : {
            key = "${rt_key}_${route_key}"
            value = {
              route_table_name = azurerm_route_table.rt[rt_key].name
              route_name       = route_key
              route            = route
            }
          }
        ] : []
      ) : []
    ]) : pair.key => pair.value
    }, {
    for pair in flatten([
      for subnet_key, subnet in var.config.subnets :
      can(subnet.route_table.routes) ? (
        subnet.route_table.routes != null ? [
          for route_key, route in subnet.route_table.routes : {
            key = "${subnet_key}_${route_key}"
            value = {
              route_table_name = azurerm_route_table.rt[subnet_key].name
              route_name       = route_key
              route            = route
            }
          }
        ] : []
      ) : []
    ]) : pair.key => pair.value
  })

  name                   = each.value.route_name
  resource_group_name    = var.config.resource_group_name
  route_table_name       = each.value.route_table_name
  address_prefix         = each.value.route.address_prefix
  next_hop_type          = each.value.route.next_hop_type
  next_hop_in_ip_address = lookup(each.value.route, "next_hop_in_ip_address", null)
}

# Route table associations
resource "azurerm_subnet_route_table_association" "rt_as" {
  for_each = {
    for subnet_key, subnet in var.config.subnets : subnet_key => subnet
    if subnet.route_table_shared != null || subnet.route_table != null
  }

  subnet_id      = azurerm_subnet.subnets[each.key].id
  route_table_id = each.value.route_table_shared != null ? azurerm_route_table.rt[each.value.route_table_shared].id : azurerm_route_table.rt[each.key].id
}
