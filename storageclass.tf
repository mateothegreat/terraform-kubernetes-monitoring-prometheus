resource "kubernetes_storage_class" "prometheus" {

    metadata {

        name = var.name

    }

    storage_provisioner    = "kubernetes.io/aws-ebs"
    reclaim_policy         = "Delete"
    allow_volume_expansion = true
    volume_binding_mode    = "Immediate"

    parameters = {

        type = "gp2"

    }

}
