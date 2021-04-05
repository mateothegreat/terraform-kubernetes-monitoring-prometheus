resource "kubernetes_config_map" "global-config" {

    metadata {

        name      = "${ var.name }-global-config"
        namespace = var.namespace

    }

    data = {

        "prometheus.yaml" = yamlencode({

            global = {

                scrape_interval = var.scrape_interval
                scrape_timeout  = var.scrape_timeout
                external_labels = var.external_labels

            }

            scrape_configs = [

                #                {
                #
                #                    job_name = "kubernetes-service-endpoints"
                #
                #                    kubernetes_sd_configs = [
                #
                #                        {
                #
                #                            role = "endpoints"
                #
                #                        }
                #
                #                    ]
                #
                #                    relabel_configs = [
                #
                #                        {
                #
                #                            action = "labelmap"
                #                            regex  = "__meta_kubernetes_service_label_(.+)"
                #
                #                        }, {
                #
                #                            source_labels = ["__meta_kubernetes_namespace"]
                #                            action = "replace"
                #                            target_label = "kubernetes_namespace"
                #
                #                        }, {
                #
                #                            source_labels = ["__meta_kubernetes_service_name"]
                #                            action = "replace"
                #                            target_label = "kubernetes_name"
                #
                #                        }
                #
                #                    ]
                #
                #                }
                {

                    job_name = "kubernetes-pods"

                    kubernetes_sd_configs = [

                        {

                            role = "pod"

                        }

                    ]

                    relabel_configs = [

                        {

                            source_labels = [ "__meta_kubernetes_pod_annotation_prometheus_io_scrape" ]
                            action        = "keep"
                            regex         = "true"

                        }, {

                            source_labels = [ "__address__", "__meta_kubernetes_pod_annotation_prometheus_io_port" ]
                            action        = "replace"
                            regex         = "([^:]+)(?::\\d+)?;(\\d+)"
                            #                            regex         = "(.*?):.*?;(\\d+)"
                            replacement   = "$1:$2"
                            target_label  = "__address__"

                        }, {

                            source_labels = [ "__meta_kubernetes_pod_annotation_prometheus_io_path" ]
                            action        = "replace"
                            target_label  = "__metrics_path__"
                            regex         = "(.+)"

                        }, {

                            action = "labelmap"
                            regex  = "__meta_kubernetes_pod_label_(.+)"

                        }, {

                            source_labels = [ "__meta_kubernetes_namespace" ]
                            action        = "replace"
                            target_label  = "namespace"

                        }, {

                            source_labels = [ "__meta_kubernetes_pod_name" ]
                            action        = "replace"
                            target_label  = "pod"

                        }, {

                            source_labels = [ "pod_template_generation" ]
                            target_label  = "pod_template_generation"
                            action        = "replace"
                            replacement   = ""

                        }, {

                            source_labels = [ "pod_template_hash" ]
                            target_label  = "pod_template_hash"
                            action        = "replace"
                            replacement   = ""

                        }

                    ]

                }

            ]

        })

    }

}
