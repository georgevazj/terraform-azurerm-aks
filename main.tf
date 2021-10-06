terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {
  }
}

module "workload" {
  source  = "app.terraform.io/georgevazj-lab/workload/azure"
  version = "0.0.16"

  description      = var.description
  workload_acronym = var.workload_acronym
}

data "azurerm_subnet" "subnet" {
  name                 = var.snet_name
  resource_group_name  = var.vnet_rsg_name
  virtual_network_name = var.vnet_name
}

resource "azurerm_private_dns_zone" "dns_zone" {
  name                = "privatelink.westeurope.azmk8s.io"
  resource_group_name = module.workload.resource_group_name
}

resource "azurerm_user_assigned_identity" "msi" {
  location            = module.workload.resource_group_location
  name                = var.aks_name
  resource_group_name = module.workload.resource_group_name
}

resource "azurerm_role_assignment" "role" {
  principal_id = azurerm_user_assigned_identity.msi.principal_id
  scope        = azurerm_private_dns_zone.dns_zone.id
  role_definition_name = "Private DNS Zone Contributor"
}

resource "azurerm_kubernetes_cluster" "aks" {
  location            = module.workload.resource_group_location
  name                = var.aks_name
  resource_group_name = module.workload.resource_group_name
  dns_prefix_private_cluster = var.dns_prefix
  private_cluster_enabled = true
  private_dns_zone_id = azurerm_private_dns_zone.dns_zone.id

  default_node_pool {
    name    = var.nodepool_name
    enable_auto_scaling = var.enable_autoscaling
    node_count     = var.node_count
    type           = "VirtualMachineScaleSets"
    vm_size = var.vm_size
    vnet_subnet_id = data.azurerm_subnet.subnet.id
  }

  network_profile {
    network_plugin = "kubenet"
    load_balancer_sku = "standard"
    outbound_type = var.outbound_type
    network_policy = var.network_policy
  }

  addon_profile {
    aci_connector_linux {
      enabled = false
    }

    azure_policy {
      enabled = false
    }

    http_application_routing {
      enabled = false
    }

    kube_dashboard {
      enabled = true
    }

    oms_agent {
      enabled = false
    }
  }
}

