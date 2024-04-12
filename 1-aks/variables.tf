variable "name" {
  type        = string
  default     = ""
  description = "Default name for resources"
}

variable "role" {
  type        = string
  default     = "adoa"
  description = "Default name for role"
}

variable "environment" {
  type        = string
  default     = "demo"
  description = "Default name for environment"
}

variable "location" {
  type        = string
  default     = "westeurope"
  description = "Location of the resource group."
}

variable "vm_size" {
  type        = string
  description = "Default size of the VMSS"
  default     = "Standard_B2as_v2"
}


variable "node_count" {
  type        = number
  description = "Default quantity of nodes for the node pool."
  default     = 2
}

variable "os_sku" {
  type        = string
  description = "Default size of the VMSS"
  default     = "AzureLinux"
}

variable "username" {
  type        = string
  description = "User for the new cluster."
  default     = "aaaks"
}

variable "acr_sku" {
  type        = string
  default     = "Standard"
  description = "ACR sku"
}

variable "image_version" {
  type        = string
  description = "image version"
  default     = "latest"
}

variable "image_base" {
  type        = string
  description = "Base image for Azure Pipeline agent"
  default     = "ubuntu"
}

variable "org_name" {
  type        = string
  description = "Organization Name"
  default     = ""
}

variable "pool_name" {
  type        = string
  description = "Azure DevOps Pipeline Pool Name"
  default     = ""
}

variable "ado_token" {
  type        = string
  description = "Azure DevOps PAT"
  default     = ""
  sensitive   = true
}

variable "replicas" {
  type        = number
  description = "Number of replicas"
  default     = 1
}

variable "requests" {
  default = {
    cpu    = "100m"
    memory = "512Mi"
  }
}

variable "limits" {
  default = {
    memory = "2Gi"
  }
}

variable "disk_space_limit" {
  default = "4Gi"
}

