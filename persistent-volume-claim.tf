resource "kubernetes_persistent_volume_claim" "data" {

    depends_on = [

        kubernetes_deployment.deployment

    ]

    metadata {

        namespace = var.namespace
        name      = var.name

    }

    spec {

        storage_class_name = "gp2"

        access_modes = [ "ReadWriteOnce" ]

        resources {

            requests = {

                storage = var.volume_size

            }

        }

    }

}