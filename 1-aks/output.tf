output "cluster_name" {
  value = azurerm_kubernetes_cluster.ado.name
}

output "acr_name" {
  value = azurerm_container_registry.acr_azp-agent.name
}

