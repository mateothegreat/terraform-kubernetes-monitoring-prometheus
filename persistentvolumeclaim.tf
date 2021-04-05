resource "kubernetes_persistent_volume_claim" "prometheus" {

    depends_on = [ kubernetes_persistent_volume.prometheus ]

    wait_until_bound = true

    metadata {

        name      = var.name
        namespace = var.namespace

        labels = {

            app = var.name

        }

    }

    spec {

        volume_name  = kubernetes_persistent_volume.prometheus.metadata.0.name
        access_modes = [ "ReadWriteOnce" ]

        resources {

            requests = {

                storage = "20Gi"

            }

        }

        storage_class_name = kubernetes_storage_class.expandable.metadata.0.name

    }

}
