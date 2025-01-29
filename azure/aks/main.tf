provider "azurerm" {
  features {}
  subscription_id = "2824b061-b318-4703-b222-a5c7b90310ce"
}

# Data source to fetch existing Resource Group
data "azurerm_resource_group" "rg" {
  name = "prod-project636-rg"
}

# Data source to fetch existing Virtual Network by name
data "azurerm_virtual_network" "existing_vnet" {
  name                = "prod-project636-vnet"  # Replace with your existing VNet name
  resource_group_name = data.azurerm_resource_group.rg.name
}

# Create an AKS Cluster
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "prod-project636-cluster"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  dns_prefix          = "prod-project636-cluster"

  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = "Standard_D2_v2"  # Replace with your desired VM size
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
    service_cidr   = "10.0.0.0/16"
    dns_service_ip = "10.0.0.10"
    # docker_bridge_cidr is no longer supported
  }

  # Replace addon_profile with specific add-on configurations
  azure_policy_enabled = true

  tags = {
    Name = "prod-project636-cluster"
  }
}

# Create a Role Assignment for AKS to access the VNet
resource "azurerm_role_assignment" "aks_vnet_role" {
  scope                = data.azurerm_virtual_network.existing_vnet.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_kubernetes_cluster.aks.identity[0].principal_id
}