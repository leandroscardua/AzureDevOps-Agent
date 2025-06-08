data "azurerm_client_config" "current" {}

data "azuread_client_config" "current" {}

data "azurerm_subscription" "primary" {}

resource "azuread_group" "aks_admin" {
  display_name     = "cluster-administrators-${local.aks_name}"
  description      = "Azure AKS Kubernetes administrators for the"
  security_enabled = true

  members = [
    data.azuread_client_config.current.object_id
  ]
}

resource "azurerm_role_assignment" "aks_admin" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Azure Kubernetes Service RBAC Cluster Admin"
  principal_id         = azuread_group.aks_admin.object_id

  depends_on = [azuread_group.aks_admin]
}

resource "azurerm_role_assignment" "aks_admin_2" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Azure Kubernetes Service Cluster User Role"
  principal_id         = azuread_group.aks_admin.object_id

  depends_on = [azurerm_role_assignment.aks_admin]

}

resource "azurerm_role_assignment" "aks_admin_3" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Azure Kubernetes Service RBAC Reader"
  principal_id         = azuread_group.aks_admin.object_id

  depends_on = [azurerm_role_assignment.aks_admin_2]

}

resource "time_sleep" "wait_60_seconds" {
  create_duration = "60s"
  depends_on = [
    azurerm_role_assignment.aks_admin_3,
    azurerm_kubernetes_cluster_node_pool.app_pool
  ]
}
