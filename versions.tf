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
