resource "azurerm_resource_group" "testrg" {
  name     = "mytestrg"
  location = "centralindia"
  tags = {
    environment = "dev"
  }
}

resource "azurerm_virtual_network" "test-vnet" {
  name                = "mytestvnet"
  resource_group_name = azurerm_resource_group.testrg.name
  location            = azurerm_resource_group.testrg.location
  address_space       = ["10.1.0.0/16"]

  tags = {
    environment = "dev"
  }
}

resource "azurerm_subnet" "testsubnet" {
  name                 = "mytestsubnet"
  resource_group_name  = azurerm_resource_group.testrg.name
  virtual_network_name = azurerm_virtual_network.test-vnet.name
  address_prefixes     = ["10.1.1.0/24"]
}

resource "azurerm_network_security_group" "testnsg" {
  name                = "mytestnsg"
  resource_group_name = azurerm_resource_group.testrg.name
  location            = azurerm_resource_group.testrg.location

  tags = {
    environment = "dev"
  }
}

resource "azurerm_network_security_rule" "testnsr" {
  name                        = "mytestnsr"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = 22
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.testrg.name
  network_security_group_name = azurerm_network_security_group.testnsg.name
}

resource "azurerm_subnet_network_security_group_association" "testsnsga" {
  subnet_id                 = azurerm_subnet.testsubnet.id
  network_security_group_id = azurerm_network_security_group.testnsg.id
}

resource "azurerm_public_ip" "testip" {
  for_each = { for k, v in var.nodes : k => v if v.public }

  name                = "mytestip-${each.value.name}"
  resource_group_name = azurerm_resource_group.testrg.name
  location            = azurerm_resource_group.testrg.location
  allocation_method   = "Dynamic"

  tags = {
    environment = "dev"
  }
}

resource "azurerm_network_interface" "testnic" {
  for_each = var.nodes

  name                = "mytestnic-${each.value.name}"
  location            = azurerm_resource_group.testrg.location
  resource_group_name = azurerm_resource_group.testrg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.testsubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = each.value.public ? azurerm_public_ip.testip[each.key].id : null
  }

  tags = {
    environment = "dev"
  }
}

resource "azurerm_linux_virtual_machine" "testvm" {
  for_each = var.nodes

  name                = each.value.name
  resource_group_name = azurerm_resource_group.testrg.name
  location            = azurerm_resource_group.testrg.location
  size                = each.value.node_size
  admin_username      = each.value.admin_username

  network_interface_ids = [
    azurerm_network_interface.testnic[each.key].id,
  ]

  admin_ssh_key {
    username   = each.value.admin_username
    public_key = file("path/to/public-key")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "debian"
    offer     = "debian-12"
    sku       = "12"
    version   = "latest"
  }
}
