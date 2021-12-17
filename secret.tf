provider "aws" {

    alias   = "mlfabric"
    profile = "mlfabric"
    region  = "us-east-1"

}

data "aws_secretsmanager_secret" "thanos-write" {

    provider = aws.mlfabric

    name = "mlfabric-monitoring-platform-thanos-write"

}

data "aws_secretsmanager_secret_version" "thanos-write" {

    provider = aws.mlfabric

    secret_id = data.aws_secretsmanager_secret.thanos-write.id

}

resource "kubernetes_secret" "obstore-config" {

    metadata {

        name      = "${ var.name }-objstore-conf"
        namespace = var.namespace

    }

    data = {

        "objstore.yaml" = jsonencode({

            type = "s3"

            config = jsondecode(data.aws_secretsmanager_secret_version.thanos-write.secret_string)

        })

    }

}
