resource "kubernetes_service" "prometheus" {

    metadata {

        name      = var.name
        namespace = var.namespace

        labels = {

            app = var.name

        }

        annotations = {

            "service.beta.kubernetes.io/aws-load-balancer-type"     = "nlb"
            "service.beta.kubernetes.io/aws-load-balancer-internal" = var.loadbalancer_internal ? "true" : null

        }

    }

    spec {

        type = var.loadbalancer_enabled ? "LoadBalancer" : "ClusterIP"

        selector = {

            app = var.name

        }

        port {

            name        = "prom"
            port        = 9090
            target_port = 9090

        }

        port {

            name        = "gprc"
            port        = 10901
            target_port = 10901

        }

        port {

            name        = "http"
            port        = 10902
            target_port = 10902

        }

    }

}
