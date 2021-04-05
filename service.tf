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

            port        = 9090
            target_port = 9090

        }

    }

}
