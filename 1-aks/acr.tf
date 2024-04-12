resource "random_string" "name" {
  length           = 3
  special          = false
  lower = true
}

resource "azurerm_resource_group" "ado" {
  name     = local.rg_name
  location = var.location
}

resource "azurerm_container_registry" "acr_azp-agent" {
  location            = azurerm_resource_group.ado.location
  name                = local.acr_name
  resource_group_name = azurerm_resource_group.ado.name
  sku                 = var.acr_sku

  tags = local.tags

  depends_on = [ azurerm_role_assignment.aks_admin_3]
}
