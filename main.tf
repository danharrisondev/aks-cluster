terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.93.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_aks01" {
  name     = "rg-aks01"
  location = "West Europe"
}

resource "azurerm_kubernetes_cluster" "aks01" {
  name                = "aks01"
  location            = azurerm_resource_group.rg_aks01.location
  resource_group_name = azurerm_resource_group.rg_aks01.name
  dns_prefix          = "dhaks01"
  default_node_pool {
    name       = "default"
    node_count = 3
    vm_size    = "Standard_B2s"
  }
  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Test"
  }
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.aks01.kube_config.0.client_certificate
  sensitive = true
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.aks01.kube_config_raw
  sensitive = true
}