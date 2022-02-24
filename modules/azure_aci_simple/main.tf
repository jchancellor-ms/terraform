#minor modifications from the terraform examples in the aci repo
resource "random_string" "namestring" {
  length  = 4
  special = false
  upper   = false
  lower   = true
}

resource "azurerm_resource_group" "test" {
  name     = "rg-${var.prefix}-${random_string.namestring.result}"
  location = var.location
}

resource "azurerm_container_group" "testgroup" {
  name                = "${var.prefix}-${random_string.namestring.result}"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  ip_address_type     = "public"
  dns_name_label      = "${var.prefix}-examplecont"
  os_type             = "linux"

  container {
    name   = "hw"
    image  = "mcr.microsoft.com/azuredocs/aci-helloworld:latest"
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 80
      protocol = "TCP"
    }
  }

  container {
    name   = "sidecar"
    image  = "mcr.microsoft.com/azuredocs/aci-tutorial-sidecar"
    cpu    = "0.5"
    memory = "1.5"
  }

  tags = {
    environment = "testing"
  }
}