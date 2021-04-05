data "external" "htpasswd" {

    program = [ "jq", "-n", "--arg", "hash", "\"$(htpasswd -bn a b)\"", "{\"hash\":$hash}" ]

}

resource "kubernetes_secret" "auth" {

    count = length(var.username) > 0 && length(var.password) > 0 ? 1 : 0

    metadata {

        name      = "${ var.name }-basicauth"
        namespace = var.namespace

    }

    data = {

        auth = data.external.htpasswd.result.hash

    }

}
