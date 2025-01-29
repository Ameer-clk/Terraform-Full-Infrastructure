# Azure Provider Configuration
provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "prod-project636-rg" {
  name     = "prod-project636-rg"
  location = "East US"  # Replace with your desired region
}

# Resource for the Virtual-network
module "prod-project636-vnet" {
  source  = "Azure/network/azurerm"
  version = "~> 3.0"

  resource_group_name = azurerm_resource_group.prod-project636-rg.name

  vnet_name     = "prod-project636-vnet"
  address_space = "10.2.0.0/16" # Provide the address space as a string
  subnet_names    = ["public-subnet-1", "public-subnet-2", "public-subnet-3", "private-subnet-1", "private-subnet-2", "private-subnet-3"]
  subnet_prefixes = ["10.2.0.0/22", "10.2.4.0/22", "10.2.24.0/22", "10.2.8.0/22", "10.2.12.0/22", "10.2.16.0/22"]

  tags = {
    Terraform   = "true"
    Environment = "prod"
  }

  depends_on = [azurerm_resource_group.prod-project636-rg]
}

# Network Security Group (NSG) for Public Subnets
resource "azurerm_network_security_group" "prod-project636-nsg" {
  name                = "prod-project636-nsg"
  location            = azurerm_resource_group.prod-project636-rg.location
  resource_group_name = azurerm_resource_group.prod-project636-rg.name

  # Security Rules
  security_rule {
    name                       = "Allow-HTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-HTTPS"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-All-Outbound"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Tags
  tags = {
    Name        = "prod-project636-nsg"
    Environment = "prod"
  }
}
