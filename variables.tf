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

variable "s3_aws_access_key_id" {

    type    = string
    default = ""

}

variable "s3_aws_secret_access_key" {

    type    = string
    default = ""

}

variable "s3_bucket" {

    type    = string
    default = ""

}

variable "s3_endpoint" {

    type    = string
    default = "s3.us-east-1.amazonaws.com"

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

variable "image" {

    type        = string
    description = "https://github.com/prometheus/prometheus/releases"
    default     = "quay.io/prometheus/prometheus:v2.25.2"

}

variable "storage_gb" {

    type        = number
    description = "storage amount for prometheus (minimum 20Gi for AWS)"
    default     = 20

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

    type = bool
    description = "if enabled creates an ingress mapping at /promtetheus (requires an ingress-controller)"
    default = false

}

variable "thanos_loadbalancer_enabled" {

    type        = bool
    description = "if enabled creates a LoadBalancer service to access the (thanos) prometheus ui/api"
    default     = false

}

variable "thanos_loadbalancer_internal" {

    type        = bool
    description = "if enabled creates a LoadBalancer service to access the (thanos) prometheus ui/api"
    default     = false

}

variable "replicas" {

    type        = number
    description = "number of replicas"
    default     = 1

}

variable "aws_resource_tags" {

    type = map(string)
    description = "tags for resources created in AWS (i.e.: EBS volumes, etc.)"
    default = null

}
