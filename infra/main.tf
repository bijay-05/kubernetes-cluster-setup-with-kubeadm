# configure the azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

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
  address_space       = ["10.123.0.0/16"]

  tags = {
    environment = "dev"
  }
}

resource "azurerm_subnet" "testsubnet" {
  name                 = "mytestsubnet"
  resource_group_name  = azurerm_resource_group.testrg.name
  virtual_network_name = azurerm_virtual_network.test-vnet.name
  address_prefixes     = ["10.123.1.0/24"]
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
  name                = "mytestip"
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
    public_ip_address_id          = azurerm_public_ip.testip.id if each.value.public
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
    azurerm_network_interface.testnic.id,
  ]

  # custom_data = filebase64("./customdata.tftpl")

  

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("./aztf_rsa.pub")
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
  connection {
      type = "ssh"
      user = "adminuser"
      private_key = file("~/.ssh/aztf_rsa")
      host = self.public_ip_address
  }

  provisioner "local-exec" {
    command = templatefile("linux-ssh-scripts.tftpl", {
      hostname     = self.public_ip_address,
      user         = "adminuser",
      identityfile = "/home/bijay/.ssh/aztf_rsa"
    })
    interpreter = ["bash", "-c"]
  }
  provisioner "file" {
    source      = "./docker.sh"
    destination = "setup.sh"
  }
  # provisioner "remote-exec" {
  #   inline = [
  #     "bash ~/setup.sh",
  #     # "source ~/.bashrc" cannot perform this on script
  #   ]
  # }
}
