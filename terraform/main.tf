terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg1" {
  name = "rg1"
  location = "eastus"
}

resource "azurerm_kubernetes_cluster" "akc1" {
  name = "akc1"
  location = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  dns_prefix = "jzd"
  
  default_node_pool {
    name = "default"
    node_count = "4"
    vm_size = "standard_d2_v2"
  }

  tags = {
    Environment = "Development"
  }

  # The AD identity and roles and permissions.
  identity {
    type = "SystemAssigned"
  }

  http_application_routing_enabled = true 
}

# resource "azurerm_kubernetes_cluster_node_pool" "auxiliary" {
#   kubernetes_cluster_id = azurerm_kubernetes_cluster.akc1.id
#   name = "auxiliary"
#   node_count = "2"
#   vm_size = "standard_d11_v2"
# }
