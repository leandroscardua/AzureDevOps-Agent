resource "terraform_data" "docker_build_push" {

  triggers_replace = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command     = <<-EOF
            cd ./image/${var.image_base}
            TOKEN=$(az acr login --name ${azurerm_container_registry.acr_azp-agent.name} --expose-token --output tsv --query accessToken)
            echo $TOKEN | nerdctl login ${azurerm_container_registry.acr_azp-agent.name}.azurecr.io -u 00000000-0000-0000-0000-000000000000 --password-stdin
            nerdctl build -t "${var.image_base}:${var.image_version}" .
            nerdctl tag "${var.image_base}:${var.image_version}" "${azurerm_container_registry.acr_azp-agent.name}.azurecr.io/${var.image_base}:${var.image_version}"
            nerdctl push "${azurerm_container_registry.acr_azp-agent.name}.azurecr.io/${var.image_base}:${var.image_version}"
    EOF
    interpreter = ["/bin/bash", "-c"]
  }
  depends_on = [azurerm_container_registry.acr_azp-agent]
}