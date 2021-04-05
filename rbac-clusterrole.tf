resource "kubernetes_cluster_role" "prometheus" {

    metadata {

        name = var.name

    }

    rule {

        api_groups = [ "" ]
        resources  = [ "nodes", "services", "endpoints", "pods" ]
        verbs      = [ "get", "list", "watch" ]

    }

    rule {

        api_groups = [ "" ]
        resources  = [ "configmaps" ]
        verbs      = [ "get" ]

    }

    rule {

        non_resource_urls = [ "/metrics" ]
        verbs             = [ "get" ]

    }

}
