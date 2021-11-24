resource "kubernetes_secret" "obstore-config" {

    metadata {

        name      = "${ var.name }-objstore-conf"
        namespace = var.namespace

    }

    data = {

        "objstore.yaml" = jsonencode({

            type = "s3"

            config = {

                bucket     = "mlfabric-devops-monitoring-thanos-1"
                endpoint   = "s3.us-east-1.amazonaws.com"
                access_key = var.s3_aws_access_key_id
                secret_key = var.s3_aws_secret_access_key

            }

        })

    }

}
