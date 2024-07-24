resource "kubernetes_namespace_v1" "namespace" {
  metadata {
    name   = var.pool_name
    labels = local.app_labels
  }
  depends_on = [
    time_sleep.wait_60_seconds
  ]
}

resource "kubernetes_service_account_v1" "service_account" {
  metadata {
    name      = var.pool_name
    namespace = kubernetes_namespace_v1.namespace.metadata[0].name
    labels    = local.app_labels
  }
}


resource "kubernetes_secret_v1" "secrets" {
  metadata {
    name      = var.pool_name
    namespace = kubernetes_namespace_v1.namespace.metadata[0].name
    labels    = local.app_labels
  }

  data = {
    AZP_URL   = "https://dev.azure.com/${var.org_name}"
    AZP_TOKEN = var.ado_token
    AZP_POOL  = var.pool_name
    AZP_WORK  = "/mnt/work"
  }
}

resource "kubernetes_deployment_v1" "ado_agent" {
  metadata {
    name      = var.pool_name
    namespace = kubernetes_namespace_v1.namespace.metadata[0].name
    labels    = local.app_labels
  }

  spec {
    replicas = var.replicas
    selector {
      match_labels = local.app_labels
    }

    template {
      metadata {
        labels = local.app_labels
      }

      spec {
        node_selector        = local.app_labels
        service_account_name = kubernetes_service_account_v1.service_account.metadata[0].name
        container {
          name  = var.pool_name
          image = "${azurerm_container_registry.acr_azp-agent.name}.azurecr.io/${var.image_base}:${var.image_version}"

          env_from {
            secret_ref {
              name = kubernetes_secret_v1.secrets.metadata[0].name
            }
          }

          volume_mount {
            name       = "temp-data"
            mount_path = "/mnt/work"
          }

          resources {
            limits   = var.limits
            requests = var.requests
          }
        }

        volume {
          name = "temp-data"
          empty_dir {
            size_limit = var.disk_space_limit
          }
        }
      }
    }
  }
}

resource "kubernetes_network_policy" "deny_all_ingress" {
  metadata {
    name      = "deny-all-ingress"
    namespace = kubernetes_service_account_v1.service_account.metadata[0].name
  }

  spec {
    pod_selector {
      match_labels = local.app_labels
    }

    policy_types = ["Ingress"]

  }
}

resource "helm_release" "keda" {
  name       = "keda"
  repository = "https://kedacore.github.io/charts"
  chart      = "keda"
  version    = "2.13.2"
  namespace  = kubernetes_namespace_v1.namespace.metadata[0].name

  depends_on = [kubernetes_deployment_v1.ado_agent]
}

resource "helm_release" "ScaledObject" {
  name      = var.pool_name
  chart     = "${path.module}/helm"
  namespace = kubernetes_namespace_v1.namespace.metadata[0].name

  set {
    name  = "name"
    value = var.pool_name
  }

  set {
    name  = "namespace"
    value = var.pool_name
  }

  set {
    name  = "minReplicaCount"
    value = var.minReplicaCount
  }

  set {
    name  = "maxReplicaCount"
    value = var.maxReplicaCount
  }

  set {
    name  = "poolName"
    value = var.pool_name
  }

  depends_on = [helm_release.keda]
}

