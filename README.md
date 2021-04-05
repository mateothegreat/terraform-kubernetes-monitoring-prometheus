# Prometheus' deployment kit for production instrumented by Terraform

* Configurable internal only or public NLB for public accessibility.
* Supports dynamically expanding the storage volume (if needed).
* Uses persistent storage to retain data between re-scheduling.
* Supports HTTP ingress routing for external access without requiring an
  additional LoadBalancer (optional)
* Supports HTTP Basic Auth for accessing the prometheus API & UI 🔐

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
    region = "us-east-1-changeme"

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
```

---

https://matthewdavis.io
