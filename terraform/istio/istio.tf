data "azurerm_resource_group" "this" {
  name = "rg_assignment"
}

resource "kubernetes_namespace" "istio_system" {
  metadata {
    name = "istio-system"
  }
}
resource "kubernetes_namespace" "istio-ingress" {
  metadata {
    name = "istio-ingress"

    labels = {
      istio-injection = "enabled"
    }
  }
}

resource "kubernetes_namespace" "bluegreen" {
  metadata {
    name = "bluegreen"

    labels = {
      istio-injection = "enabled"
    }
  }
}

resource "helm_release" "istio_base" {
  name  = "istio-base"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart = "base"

  timeout = 120
  cleanup_on_fail = true
  force_update    = false
  namespace       = kubernetes_namespace.istio_system.metadata.0.name


}

resource "helm_release" "istiod" {
  name  = "istiod"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart = "istiod"

  timeout = 120
  cleanup_on_fail = true
  force_update    = false
  namespace       = kubernetes_namespace.istio_system.metadata.0.name

  set {
    name = "meshConfig.accessLogFile"
    value = "/dev/stdout"
  }


  depends_on = [ helm_release.istio_base]
}

resource "helm_release" "istio_ingress" {
  name  = "istio-ingressgateway"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart = "gateway"

  timeout = 500
  cleanup_on_fail = true
  force_update    = false
  namespace       = kubernetes_namespace.istio-ingress.metadata.0.name

  depends_on = [ helm_release.istiod]
}
