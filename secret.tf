resource "kubernetes_secret" "obstore-config" {

    metadata {

        name      = "${ var.name }-objstore-conf"
        namespace = var.namespace

    }

    data = {

        "objstore.yaml" = var.objstore_config

    }

}
