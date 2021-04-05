resource "kubernetes_service_account" "prometheus" {

    metadata {

        name = var.name
        namespace = var.namespace

    }

}

