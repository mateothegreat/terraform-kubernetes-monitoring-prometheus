# Prometheus deployment kit for production instrumented by Terraform

https://app.terraform.io/app/MAA-ML-DEVOPS/registry/modules/private/MAA-ML-DEVOPS/monitoring-prometheus/kubernetes

```text
┌──────────────────────┐  ┌────────────┬─────────┐   ┌────────────┐
│ Google Cloud Storage │  │ Prometheus │ Sidecar │   │    Rule    │
└─────────────────┬────┘  └────────────┴────┬────┘   └─┬──────────┘
                  │                         │          │
         Block File Ranges                  │          │
                  │                     Store API      │
                  v                         │          │
                ┌──────────────┐            │          │
                │     Store    │            │      Store API
                └────────┬─────┘            │          │
                         │                  │          │
                     Store API              │          │
                         │                  │          │
                         v                  v          v
                       ┌──────────────────────────────────┐
                       │              Client              │ <-- Grafana
                       └──────────────────────────────────┘
```

* Integrated sidecar with [Thanos](https://thanos.io) + uploads to S3/GCP/etc.
* Configurable internal only or public NLB for public accessibility 🌐.
* Supports dynamically expanding the storage volume (if needed).
* Uses persistent storage to retain data between re-scheduling.
* Supports HTTP ingress routing for external access without requiring an additional LoadBalancer (optional)
* Supports HTTP Basic Auth for accessing the prometheus API & UI 🔐.
* Restrict HTTP access by ip block(s) (optional).

```sql
topk(20, count by (__name__, job)({__name__=~".+"}))
```

### Preparing to run the module

```hcl
variable "cluster_name" {

    type        = string
    description = "name of your EKS cluster"
    default     = "eks-1"

}

#
# Retrieve authentication for kubernetes from aws.
#
provider "aws" {

    profile = "someprofile-changeme"
    region  = "us-east-1-changeme"

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

#
# Connect to the kubernetes cluster using the standard provider.
#
provider "kubernetes" {

    host  = data.aws_eks_cluster.cluster.endpoint
    token = data.aws_eks_cluster_auth.cluster.token

    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[ 0 ].data)

}

#
# Connect to the kubernetes cluster using the alpha provider.
# We used the alpha provider to manage `kubernetes_manifests` resources.
#
provider "kubernetes-alpha" {

    host  = data.aws_eks_cluster.cluster.endpoint
    token = data.aws_eks_cluster_auth.cluster.token

    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[ 0 ].data)

}
```

### Usage

```hcl
module "monitoring-prometheus" {

    source  = "<change me>"
    version = "<change me>"

    name            = "prometheus-1"
    retention       = "14d"
    namespace       = "default"
    volume_size     = "100Gi"
    limit_memory    = "5Gi"
    scrape_interval = "30s"

    additional_scrape_configs = [ ]

    node_selector = {

        role = "infra"

    }

    external_labels = {

        cluster = "my-cluster-2"
        product = "api beep boop"

    }

}
```

## S3

> See https://thanos.io/tip/thanos/storage.md/#s3.

In order for thanos-sidecar to upload prometheus data to S3 you need to setup a policy like this and update the
credentials (above) assigned to it:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Statement",
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:GetObject",
                "s3:DeleteObject",
                "s3:PutObject"
            ],
            "Resource": [
                "arn:aws:s3:::<bucket>/*",
                "arn:aws:s3:::<bucket>"
            ]
        }
    ]
}
```
