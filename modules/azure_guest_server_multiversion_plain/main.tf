locals {
  admin_username = "azureuser"
}

resource "random_password" "userpass" {
  length           = 20
  special          = true
  override_special = "_-!."
}

resource "azurerm_key_vault_secret" "vmpassword" {
  name         = "${var.vm_name}-password"
  value        = random_password.userpass.result
  key_vault_id = var.key_vault_id
  depends_on   = [var.key_vault_id]
}

resource "azurerm_network_interface" "testnic" {
  name                = "${var.vm_name}-nic-1"
  location            = var.rg_location
  resource_group_name = var.rg_name
  ip_configuration {
    name                          = "${var.vm_name}-ipconfig-1"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "virtualmachine" {
  name                     = var.vm_name
  resource_group_name      = var.rg_name
  location                 = var.rg_location
  size                     = var.vm_sku
  admin_username           = local.admin_username
  tags                     = var.tags
  admin_password           = random_password.userpass.result
  license_type             = "Windows_Server"
  enable_automatic_updates = true
  patch_mode               = "AutomaticByOS"
  network_interface_ids = [
    azurerm_network_interface.testnic.id,
  ]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = var.os_version_sku
    version   = "latest"
  }
}
