resource "random_string" "name" {
  length  = 3
  special = false
  upper   = false
}

resource "azurerm_resource_group" "ado" {
  name     = local.rg_name
  location = var.location
}

resource "azurerm_kubernetes_cluster" "aks" {
  location            = azurerm_resource_group.ado.location
  name                = local.aks_name
  resource_group_name = azurerm_resource_group.ado.name
  dns_prefix          = local.aks_name
  oidc_issuer_enabled = true
  # private_cluster_enabled = true
  # private_cluster_public_fqdn_enabled = false
  workload_identity_enabled = false
  local_account_disabled    = true
  azure_active_directory_role_based_access_control {
    managed                = true
    azure_rbac_enabled     = true
    admin_group_object_ids = [azuread_group.aks_admin.id]
  }

  workload_autoscaler_profile {
    keda_enabled                    = false
    vertical_pod_autoscaler_enabled = false
  }

  default_node_pool {
    name       = "systempool"
    vm_size    = var.vm_size
    node_count = var.node_count
    os_sku     = var.os_sku
  }
  linux_profile {
    admin_username = var.username

    ssh_key {
      key_data = jsondecode(azapi_resource_action.ssh_public_key_gen.output).publicKey
    }
  }
  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = local.tags
  # tags = {
  #   Environment = "test",
  #   Role        = "ado-agent"
  # }

  depends_on = [
    azapi_resource.ssh_public_key,
    azurerm_role_assignment.aks_admin_3,
    terraform_data.docker_build_push
  ]
}

resource "azurerm_kubernetes_cluster_node_pool" "workload" {
  name                  = "workload"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = var.vm_size
  node_count            = var.node_count
  os_sku                = var.os_sku

  node_labels = local.labels

  tags = local.tags

  # tags = {
  #   Environment = "test",
  #   Role        = "ADO-agent"
  # }
  depends_on = [azurerm_kubernetes_cluster.aks]
}

resource "azurerm_role_assignment" "acr" {
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr_azp-agent.id
  skip_service_principal_aad_check = true
}
