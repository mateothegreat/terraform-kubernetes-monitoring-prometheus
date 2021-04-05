resource "kubernetes_storage_class" "expandable" {

    storage_provisioner    = "kubernetes/aws-ebs"
    reclaim_policy         = "Delete"
    allow_volume_expansion = true
    mount_options          = [ "debug" ]

    metadata {

        name = "gp2-expandable"

        annotations = {

            "storageclass.beta.kubernetes.io/is-default-class" = true

        }

    }

    parameters = {

        type = "gp2"

    }

}
