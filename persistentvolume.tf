resource "kubernetes_persistent_volume" "prometheus" {

    depends_on = [ aws_ebs_volume.prometheus ]

    metadata {

        name = var.name

        labels = {

            app = var.name

        }

    }

    spec {

        storage_class_name = "gp2-expandable"

        capacity = {

            storage = "${ var.storage_gb }Gi"

        }

        access_modes = [ "ReadWriteOnce" ]

        persistent_volume_source {

            aws_elastic_block_store {

                volume_id = aws_ebs_volume.prometheus.id

            }

        }

    }

}
