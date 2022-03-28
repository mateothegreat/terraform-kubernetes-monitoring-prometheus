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

            scrape_configs = concat(var.additional_scrape_configs, [

                {

                    job_name = "ingress-controller"

                    static_configs = [

                        {

                            targets = var.default_ingress_scrape_targets

                        }

                    ]

                },
                {

                    job_name = "elasticsearch"

                    static_configs = [

                        {

                            targets = var.default_elasticsearch_scrape_targets

                        }

                    ]

                },
                {

                    job_name = "rabbitmq"

                    static_configs = [

                        {

                            targets = var.default_rabbitmq_scrape_targets

                        }

                    ]

                },
                {

                    job_name = "node-exporter2"

                    kubernetes_sd_configs = [

                        {

                            role       = "endpoints"
                            namespaces = {

                                names = [ "monitoring" ]

                            }

                        }

                    ]
                },
                {

                    job_name = "kube-state-metrics"

                    static_configs = [

                        {

                            targets = [ "kube-state-metrics.kube-system.svc.cluster.local:8080" ]

                        }

                    ]

                }

            ])

        })

    }

}

