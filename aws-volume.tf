resource "aws_ebs_volume" "prometheus" {

    availability_zone = "us-east-1b"
    size              = var.storage_gb
    encrypted         = true

    tags = {

        Name = "${ var.name }-prometheus-persistent-storage"

    }

}
