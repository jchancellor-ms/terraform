resource "random_password" "userpass" {
  length           = 20
  special          = true
  override_special = "_-!."
}


locals {
  #import_command       = "Import-Module ADDSDeployment"
  password_command = "$password = ConvertTo-SecureString ${random_password.userpass.result} -AsPlainText -Force"

  static_ip_command    = ""
  install_ad_command   = "Add-WindowsFeature -name ad-domain-services -IncludeManagementTools"
  install_dns_command  = "Install-WindowsFeature -Name DNS -IncludeAllSubFeature -IncludeManagementTools -ErrorAction SilentlyContinue"
  configure_ad_command = "Install-ADDSForest -CreateDnsDelegation:$false -DomainMode WinThreshold -DomainName ${var.active_directory_domain} -DomainNetbiosName ${var.active_directory_netbios_name} -ForestMode WinThreshold -InstallDns:$true -SafeModeAdministratorPassword $password -Force:$true"
  #commenting out the private endpoint conditional forwarder syntax but leaving in if needed to create a separate module later
  #powershell_command_cond_fw = "Add-DnsServerConditionalForwarderZone -Name blob.core.windows.net -MasterServers ${var.firewall_ip}" 


  shutdown_command = "shutdown -r -t 10"
  exit_code_hack   = "exit 0"

  #${local.import_command};
  #; ${local.shutdown_command}; ${local.exit_code_hack}
  #powershell_command   = " ${local.password_command}; ${local.install_ad_command}; ${local.install_dns_command}; ${local.powershell_command_cond_fw}; ${local.configure_ad_command}"
  powershell_command = " ${local.password_command}; ${local.install_ad_command}; ${local.install_dns_command}; ${local.configure_ad_command}"
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
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "static"
    private_ip_address            = var.private_ip_address
  }
}


resource "azurerm_windows_virtual_machine" "testmachine" {
  name                     = var.vm_name
  resource_group_name      = var.rg_name
  location                 = var.rg_location
  size                     = var.vm_sku
  admin_username           = "azureuser"
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
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}


#run the promotion script to make the DC a VM
resource "azurerm_virtual_machine_extension" "create-active-directory-forest" {
  name                 = "create-active-directory-forest"
  virtual_machine_id   = azurerm_windows_virtual_machine.testmachine.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"

  protected_settings = <<PROTECTED_SETTINGS
    {
        "commandToExecute": "powershell.exe -Command \"${local.powershell_command}\""
    }
PROTECTED_SETTINGS
}

/*
resource "azurerm_virtual_machine_extension" "configure-dns-forwarder" {
  name                 = "configure-dns-forwarder-privatelink-blob"
  virtual_machine_id = azurerm_windows_virtual_machine.testmachine.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"
  #depends_on = [
  #  azurerm_virtual_machine_extension.create-active-directory-forest
  #]
  settings = <<SETTINGS
    {
        "commandToExecute": "powershell.exe -Command \"${local.powershell_command_cond_fw}\""
    }
SETTINGS
}

*/