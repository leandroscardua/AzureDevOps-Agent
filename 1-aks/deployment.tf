resource "kubernetes_namespace_v1" "namespace" {
  metadata {
    name   = var.pool_name
    labels = local.app_labels
  }
  depends_on = [
    time_sleep.wait_60_seconds
  ]
}

resource "helm_release" "keda" {
  name       = "keda"
  repository = "https://kedacore.github.io/charts"
  chart      = "keda"
  version    = "2.15.1"
  namespace  = kubernetes_namespace_v1.namespace.metadata[0].name

  depends_on = [kubernetes_namespace_v1.namespace]
}

resource "helm_release" "ScaledObject" {
  name          = var.pool_name
  chart         = "${path.module}/helm"
  namespace     = kubernetes_namespace_v1.namespace.metadata[0].name
  force_update  = true
  recreate_pods = true
  wait          = true

  set {
    name  = "name"
    value = var.pool_name
  }

  set {
    name  = "poolName"
    value = var.pool_name
  }

  set {
    name  = "orgName"
    value = "https://dev.azure.com/${var.org_name}"
  }

  set_sensitive {
    name  = "token"
    value = sensitive(var.ado_token)
  }

  set {
    name  = "namespace"
    value = kubernetes_namespace_v1.namespace.metadata[0].name
  }
  set {
    name  = "image"
    value = local.image
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
    name  = "tags"
    value = yamlencode(local.app_labels)
  }

  set {
    name  = "limits.cpu"
    value = var.limits["cpu"]
  }

  set {
    name  = "limits.memory"
    value = var.limits["memory"]
  }
  set {
    name  = "requests.cpu"
    value = var.requests["cpu"]
  }

  set {
    name  = "requests.memory"
    value = var.requests["memory"]
  }

  set {
    name  = "disk_space_limit"
    value = var.disk_space_limit
  }

  # set {
  #   name  = "podAnnotations.restartedAt"
  #   value = timestamp()
  # }

  depends_on = [helm_release.keda]
}
