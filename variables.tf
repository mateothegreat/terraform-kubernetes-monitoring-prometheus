variable "name" {

    type        = string
    description = "prometheus operated name"

}

variable "namespace" {

    type        = string
    description = "prometheus operated namespace"

}

variable "username" {

    type        = string
    description = "username to login with (basic auth)"

}

variable "password" {

    type        = string
    description = "username to login with (basic auth)"

}

variable "external_labels" {

    type        = map(string)
    description = "labels to add to metrics when queried externally"
    default     = null

}

variable "request_cpu" {

    type        = string
    description = "requested cpu"
    default     = "200m"

}

variable "request_memory" {

    type        = string
    description = "requested memory"
    default     = "200Mi"

}

variable "limit_cpu" {

    type        = string
    description = "cpu limit"
    default     = "250m"

}

variable "limit_memory" {

    type        = string
    description = "memory limit"
    default     = "250Mi"

}

variable "retention" {

    type        = string
    description = "retention period (i.e.: 6h)"
    default     = "24h"

}

variable "block_duration" {

    type        = string
    description = "block duration period (i.e.: 6h)"
    default     = "15m"

}

variable "image" {

    type        = string
    description = "https://github.com/prometheus/prometheus/releases"
    default     = "quay.io/prometheus/prometheus:v2.25.2"

}

variable "scrape_interval" {

    type        = string
    description = "how often to scrape targets"
    default     = "10s"

}

variable "scrape_timeout" {

    type        = string
    description = "how long to wait for a scrape to occur"
    default     = "5s"

}

variable "node_selector" {

    type        = map(string)
    description = "labels to determine which node we run on"
    default     = {}

}

variable "loadbalancer_enabled" {

    type        = bool
    description = "if enabled creates a LoadBalancer service to access the prometheus ui/api"
    default     = false

}

variable "loadbalancer_internal" {

    type        = bool
    description = "if enabled creates a LoadBalancer service to access the prometheus ui/api"
    default     = false

}

variable "ingress_enabled" {

    type        = bool
    description = "if enabled creates an ingress mapping at /promtetheus (requires an ingress-controller)"
    default     = false

}

variable "ingress_whitelist" {

    type        = string
    description = "comma-delimited cidr block(s) to lock the ingress down to"
    default     = "0.0.0.0/0"

}


variable "thanos_image" {

    type        = string
    description = "thanos query image"
    default     = "quay.io/thanos/thanos:v0.19.0"

}

variable "replicas" {

    type        = number
    description = "number of replicas"
    default     = 1

}

variable "aws_resource_tags" {

    type        = map(string)
    description = "tags for resources created in AWS (i.e.: EBS volumes, etc.)"
    default     = null

}


variable "objstore_config" {

    type        = string
    description = "s3 configig"
    default     = null

}

variable "additional_scrape_configs" {

    description = "additional scrape configs (see: https://prometheus.io/docs/prometheus/latest/configuration/configuration/#scrape_config)"
    default = null

}

variable "volume_size" {

    type = string
    description = "persistent volume size"
    default = "10Gi"

}