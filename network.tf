# Create Virtual Network (VNet)
resource "azurerm_virtual_network" "vnet-saa" {
  name                = "vnet-saa"
  address_space       = ["10.30.0.0/16"]
  location            = azurerm_resource_group.rg-saa.location
  resource_group_name = azurerm_resource_group.rg-saa.name
}

# Create subnet 01 on VNet
resource "azurerm_subnet" "subnet-saa" {
  name                 = "subnet-saa"
  resource_group_name  = azurerm_resource_group.rg-saa.name
  address_prefixes     = ["10.30.1.0/24"]
  virtual_network_name = azurerm_virtual_network.vnet-saa.name
}

# Create Network Security Group (NSG)
resource "azurerm_network_security_group" "nsg-saa" {
  name                = "nsg-saa"
  location            = azurerm_resource_group.rg-saa.location
  resource_group_name = azurerm_resource_group.rg-saa.name

  security_rule {
    name                       = "RDP"
    priority                   = 500
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP"
    priority                   = 600
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "10.30.1.4"
  }
}

# Create Public IP
resource "azurerm_public_ip" "pip-saa" {
  name                = "pip-saa01"
  location            = azurerm_resource_group.rg-saa.location
  resource_group_name = azurerm_resource_group.rg-saa.name
  allocation_method   = "Static"
}

# Create Network Internface
resource "azurerm_network_interface" "nic-saa" {
  name                = "nic-saa01"
  location            = azurerm_resource_group.rg-saa.location
  resource_group_name = azurerm_resource_group.rg-saa.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet-saa.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip-saa.id
  }
}