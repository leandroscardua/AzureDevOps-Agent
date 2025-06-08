locals {

  rg_name = "ado${random_string.name.result}${var.role}${var.environment}"

  rg_name_acr = "adoacr${random_string.name.result}${var.role}${var.environment}"

  acr_name = "acr${random_string.name.result}${var.role}${var.environment}"

  aks_name = "aks${random_string.name.result}${var.role}${var.environment}"

  ssh_name = "ssh${random_string.name.result}${var.role}${var.environment}"

  keyvaul_name = "kv${random_string.name.result}${var.role}${var.environment}"

  secret_name = "azp-token"

  image = "${azurerm_container_registry.acr_azp-agent.name}.azurecr.io/${var.image_base}:${var.image_version}"

  tags = {
    environment = "test"
    role        = "ado-agent"
    source      = "terraform"
  }

  app_labels = {
    "app" = "ado-agent"
  }


}
