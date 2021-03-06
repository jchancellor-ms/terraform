resource "azurerm_public_ip" "bastion-pip" {
  name                = var.pip_name
  location            = var.rg_location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
  sku                 = "Standard"
  availability_zone   = "No-Zone"
}

resource "azurerm_bastion_host" "bastion" {
  name                = var.bastion_name
  location            = var.rg_location
  resource_group_name = var.rg_name

  ip_configuration {
    name                 = "bastion_ip_configuration"
    subnet_id            = var.bastion_subnet_id
    public_ip_address_id = azurerm_public_ip.bastion-pip.id
  }
}