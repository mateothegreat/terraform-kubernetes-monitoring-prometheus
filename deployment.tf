resource "kubernetes_deployment" "deployment" {

    depends_on = [ kubernetes_persistent_volume_claim.prometheus ]

    metadata {

        name      = var.name
        namespace = var.namespace

        labels = {

            app = var.name

        }

    }

    spec {

        replicas = var.replicas

        selector {

            match_labels = {

                app = var.name

            }

        }

        template {

            metadata {

                labels = {

                    app = var.name

                }

                annotations = {

                    "prometheus.io/scrape" = true
                    "prometheus.io/port"   = 9090

                }

            }

            spec {

                node_selector        = var.node_selector
                service_account_name = var.name

                init_container {

                    name    = "permissions"
                    image   = "busybox"
                    command = [ "sh", "-c", "chown -R 472:472 /var/lib/prometheus" ]

                    volume_mount {

                        name       = "varlibprometheus"
                        mount_path = "/var/lib/prometheus"

                    }

                }

                container {

                    name              = var.name
                    image             = var.image
                    image_pull_policy = "IfNotPresent"

                    args = [

                        "--config.file=/etc/prometheus/prometheus.yml",
                        "--storage.tsdb.path=/prometheus",
                        "--storage.tsdb.retention=${ var.retention }",
                        "--storage.tsdb.min-block-duration=2h", // disable compaction to use thanos
                        "--storage.tsdb.max-block-duration=2h", // disable compaction to use thanos
                        "--web.console.libraries=/usr/share/prometheus/console_libraries",
                        "--web.console.templates=/usr/share/prometheus/console",
                        "--web.external-url=http://localhost:19090/prometheus/"

                    ]

                    security_context {

                        run_as_user = 0

                    }

                    resources {

                        limits = {

                            cpu    = var.limit_cpu
                            memory = var.limit_memory

                        }

                        requests = {

                            cpu    = var.request_cpu
                            memory = var.request_memory

                        }

                    }

                    readiness_probe {

                        http_get {

                            path = "/"
                            port = 9090

                        }

                        initial_delay_seconds = 15
                        timeout_seconds       = 5

                    }

                    liveness_probe {

                        http_get {

                            path = "/"
                            port = 9090

                        }

                        initial_delay_seconds = 15
                        timeout_seconds       = 5

                    }

                    volume_mount {

                        name       = "varlibprometheus"
                        mount_path = "/var/lib/prometheus"

                    }

                    volume_mount {

                        name       = "global-config"
                        mount_path = "/etc/prometheus/prometheus.yml"
                        sub_path   = "prometheus.yml"
                        read_only  = true

                    }

                }

                volume {

                    name = "varlibprometheus"

                    persistent_volume_claim {

                        claim_name = kubernetes_persistent_volume_claim.prometheus.metadata.0.name

                    }

                }

                volume {

                    name = "global-config"

                    config_map {

                        name = kubernetes_config_map.global-config.metadata.0.name

                        items {

                            key  = "prometheus.yaml"
                            path = "prometheus.yml"

                        }

                    }

                }

            }

        }

    }

}
