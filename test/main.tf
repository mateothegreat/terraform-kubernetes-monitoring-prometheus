variable "cluster_name" {}

#
# Retrieve authentication for kubernetes from aws.
#
provider "aws" {

    profile = "maa-ml-esg"
    region  = "us-east-1"

}

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

module "prometheus" {

    source = "../"

    name                      = "prometheus"
    retention                 = "7d"
    namespace                 = "default"
    volume_size               = "100Gi"
    limit_memory              = "5Gi"
    scrape_interval           = "30s"
    ingress_enabled           = true
    ingress_class_name        = "ops"
    additional_scrape_configs = [ ]

    node_selector = {

        role = "infra"

    }

    external_labels = {

        cluster = "maa-ml-esg-dev"
        product = "esg"

    }

}
