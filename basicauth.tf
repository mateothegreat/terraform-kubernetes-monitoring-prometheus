data "external" "htpasswd" {

    count = var.ingress_enabled && length(var.username) > 0 && length(var.password) > 0 ? 1 : 0

    program = [ "${ path.module }/bin/generate-basicauth.sh", var.username, var.password ]

}

resource "kubernetes_secret" "auth" {

    count = var.ingress_enabled && length(var.username) > 0 && length(var.password) > 0 ? 1 : 0

    metadata {

        name      = "${ var.name }-basicauth"
        namespace = var.namespace

    }

    data = {

        auth = data.external.htpasswd.0.result.hash

    }

}
