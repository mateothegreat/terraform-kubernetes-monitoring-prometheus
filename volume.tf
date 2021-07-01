resource "aws_ebs_volume" "data" {

    availability_zone = "us-east-1b"
    size              = 1024

    tags = {

        Name = var.name

    }

}