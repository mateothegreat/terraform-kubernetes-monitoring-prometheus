resource "kubernetes_persistent_volume_claim" "data" {

    metadata {

        namespace = var.namespace
        name      = var.name

    }

    spec {

        storage_class_name = "ebs-sc"

        access_modes = [ "ReadWriteOnce" ]

        resources {

            requests = {

                storage = var.volume_size

            }

        }

    }

}