# AzureDevOps-Agent

![alt text](https://github.com/leandroscardua/AzureDevOps-Agent/blob/main/keda_aks_azurepippeline.png?raw=true)

# Repositorio para testar a criar de Agent Pool usando AKS e KEDA para scale automatizado

# Requerimentos

- Terraform: > 1.8.0
- Az CLI: > 2.58
- KEDA: = 2.13
- Azure Kubernetes (AKS): 1.28.5
- nerdctl: > 1.7.1
- containerd: > 1.7.10
- Azure DevOps Organization
- Azure DevOps Agent Pool - Tipo: Self-host

# Como usar?

Ante de rodar os comandos abaixo, voce precisa criar um agent pool e gerar uma PAT com permissao de leitura e gerenciamento.

git clone https://github.com/leandroscardua/AzureDevOps-Agent.git

cd ./1-aks/

terraform init

terraform plan -var="ado_token=<coloca token aqui>" -var="org_name=<nome da organizacao>" -var="pool_name=<nome do pool agent>"

terraform apply -auto-approve -var="ado_token=<coloca token aqui>" -var="org_name=<nome da organizacao>" -var="pool_name=<nome do pool agent>"
