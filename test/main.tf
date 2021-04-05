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

#resource "kubernetes_secret" "additional-config" {
#
#    metadata {
#
#        name      = "additional-scrape-configs"
#        namespace = "test-operator-1"
#
#    }
#
#    data = {
#
#        "prometheus-additional.yaml" = ""
#
#    }
#
#}

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
