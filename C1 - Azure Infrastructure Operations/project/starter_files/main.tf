provider "azurerm" {
  features {}
}

locals {
  instance_count = var.instance
}

resource "azurerm_resource_group" "example" {
  name     = "${var.prefix}-rg"
  location = var.location
}

resource "azurerm_availability_set" "example" {
  name                = "${var.prefix}-aset"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  platform_fault_domain_count = var.instance
  platform_update_domain_count = var.instance
  managed                      = true



  tags = {
    environment = "${var.tagging}"
  }
}

resource "azurerm_virtual_network" "example" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  tags = {
    environment = "${var.tagging}"
  }
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}


resource "azurerm_public_ip" "pip" {
  name                = "${var.prefix}-pip"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  allocation_method   = "Dynamic"

  tags = {
    environment = "${var.tagging}"
  }
}

resource "azurerm_network_interface" "example" {
  count               = local.instance_count
  name                = "${var.prefix}-nic${count.index}"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location

  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    environment = "${var.tagging}"
  }
}

resource "azurerm_network_security_group" "webserver" {
  name                = "webserver"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  security_rule {
    access                     = "Allow"
    direction                  = "Inbound"
    name                       = "tls"
    priority                   = 100
    protocol                   = "Tcp"
    source_port_range          = "80"
    source_address_prefix      = "10.0.2.0"
    destination_port_range     = "443"
    destination_address_prefix = azurerm_subnet.internal.address_prefix
  }

  tags = {
    environment = "${var.tagging}"
  }
}

resource "azurerm_lb" "example" {
  name                = "${var.prefix}-lb"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.pip.id
  }

  tags = {
    environment = "${var.tagging}"
  }
}

resource "azurerm_lb_backend_address_pool" "example" {
  resource_group_name = azurerm_resource_group.example.name
  loadbalancer_id     = azurerm_lb.example.id
  name                = "BackEndAddressPool"
}

resource "azurerm_lb_nat_rule" "example" {
  resource_group_name            = azurerm_resource_group.example.name
  loadbalancer_id                = azurerm_lb.example.id
  name                           = "HTTPSAccess"
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 80
  frontend_ip_configuration_name = azurerm_lb.example.frontend_ip_configuration[0].name
}

resource "azurerm_network_interface_backend_address_pool_association" "example" {
  count                   = local.instance_count
  backend_address_pool_id = azurerm_lb_backend_address_pool.example.id
  ip_configuration_name   = "primary"
  network_interface_id    = element(azurerm_network_interface.example.*.id, count.index)
}

data "azurerm_image" "packer-image" {
  name                = "UbuntuImage-1804"
  resource_group_name = "udacity-templates-rg"
}

resource "azurerm_linux_virtual_machine" "example" {
  count                           = local.instance_count
  name                            = "${var.prefix}-vm${count.index}"
  resource_group_name             = azurerm_resource_group.example.name
  location                        = azurerm_resource_group.example.location
  availability_set_id             = azurerm_availability_set.example.id
  size                            = "Standard_D2s_V3"
  admin_username                  = "var.username"
  network_interface_ids = [
    azurerm_network_interface.example[count.index].id,
  ]

  admin_ssh_key {
    username   = "var.username"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  source_image_id = data.azurerm_image.packer-image.id

  tags = {
    environment = "${var.tagging}"
  }
}
