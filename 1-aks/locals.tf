locals {

  rg_name = "ado${random_string.name.result}${var.role}${var.environment}"

  rg_name_acr = "adoacr${random_string.name.result}${var.role}${var.environment}"

  acr_name = "acr${random_string.name.result}${var.role}${var.environment}"

  aks_name = "aks${random_string.name.result}${var.role}${var.environment}"

  ssh_name = "ssh${random_string.name.result}${var.role}${var.environment}"

  tags = {
    environment = "test"
    role        = "ado-agent"
    source      = "terraform"
  }

  labels = {
    "nodepool" = "${var.pool_name}"
  }


}
