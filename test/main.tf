terraform {

    required_providers {

        kubernetes-alpha = {

            source  = "hashicorp/kubernetes-alpha"
            version = "0.2.1"

        }

        kubernetes = {

            source  = "hashicorp/kubernetes"
            version = "2.0.0"

        }

        aws = {

            source  = "hashicorp/aws"
            version = "3.30.0"

        }

    }

}

variable "cluster_name" {}

#
# Retrieve authentication for kubernetes from aws.
#
provider "aws" {}

#
# Get kubernetes cluster info.
#
data "aws_eks_cluster" "cluster" {

    name = var.cluster_name

}

#
# Retrieve authentication for kubernetes from aws.
#
data "aws_eks_cluster_auth" "cluster" {

    name = var.cluster_name

}

provider "kubernetes" {

    host  = data.aws_eks_cluster.cluster.endpoint
    token = data.aws_eks_cluster_auth.cluster.token

    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[ 0 ].data)

}

provider "kubernetes-alpha" {

    host  = data.aws_eks_cluster.cluster.endpoint
    token = data.aws_eks_cluster_auth.cluster.token

    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[ 0 ].data)

}

module "prometheus" {

    source = "../"

    name            = "prometheus-1"
    retention       = "7d"
    namespace       = "m-1"
    storage_gb      = 20
    limit_memory    = "1024Mi"
    scrape_interval = "5s"
    username        = "admin"
    password        = "password"
    ingress_enabled = true

    node_selector = {

        role = "infra"

    }

    external_labels = {

        cluster = "my-cluster-2"
        product = "api beep boop"

    }

}
