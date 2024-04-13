resource "azurerm_resource_group" "ado_acr" {
  name     = local.rg_name_acr
  location = var.location
}

resource "azurerm_container_registry" "acr_azp-agent" {
  location            = azurerm_resource_group.ado_acr.location
  name                = local.acr_name
  resource_group_name = azurerm_resource_group.ado_acr.name
  sku                 = var.acr_sku

  tags = local.tags

  depends_on = [azurerm_role_assignment.aks_admin_3]
}
