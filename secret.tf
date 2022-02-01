resource "kubernetes_secret" "obstore-config" {

    metadata {

        name      = "${ var.name }-objstore-conf"
        namespace = var.namespace

    }

    data = {

        "objstore.yaml" = yamlencode({

            type   = "s3"
            config = var.thanos_secret_config

        })

    }

}
