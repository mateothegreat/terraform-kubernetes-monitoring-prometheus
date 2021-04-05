```

       /$$                                                                          /$$                 /$$      
      | $$                                                                         | $$                | $$      
  /$$$$$$$  /$$$$$$  /$$    /$$ /$$$$$$   /$$$$$$   /$$$$$$$     /$$$$$$   /$$$$$$ | $$$$$$$   /$$$$$$ | $$$$$$$
 /$$__  $$ /$$__  $$|  $$  /$$//$$__  $$ /$$__  $$ /$$_____/    /$$__  $$ /$$__  $$| $$__  $$ |____  $$| $$__  $$
| $$  | $$| $$$$$$$$ \  $$/$$/| $$  \ $$| $$  \ $$|  $$$$$$    | $$  \__/| $$$$$$$$| $$  \ $$  /$$$$$$$| $$  \ $$
| $$  | $$| $$_____/  \  $$$/ | $$  | $$| $$  | $$ \____  $$   | $$      | $$_____/| $$  | $$ /$$__  $$| $$  | $$
|  $$$$$$$|  $$$$$$$   \  $/  |  $$$$$$/| $$$$$$$/ /$$$$$$$//$$| $$      |  $$$$$$$| $$  | $$|  $$$$$$$| $$$$$$$/
 \_______/ \_______/    \_/    \______/ | $$____/ |_______/|__/|__/       \_______/|__/  |__/ \_______/|_______/
                                        | $$                                                                     
                                        | $$                                                                     
                                        |__/                                                                     
```
https://devops.rehab/docs/terraform | https://matthewdavis.io

# Prometheus' deployment kit for production instrumented by Terraform

* Configurable internal only or public NLB for public accessibility 🌐.
* Supports dynamically expanding the storage volume (if needed).
* Uses persistent storage to retain data between re-scheduling.
* Supports HTTP ingress routing for external access without requiring an
  additional LoadBalancer (optional)
* Supports HTTP Basic Auth for accessing the prometheus API & UI 🔐.

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
module "monitoring-prometheus" {
  
    source  = "mateothegreat/monitoring-prometheus/kubernetes"
    version = "replace me (see: https://registry.terraform.io/modules/mateothegreat/monitoring-prometheus/kubernetes/latest)"

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
<!-- BEGIN_TF_DOCS -->

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 3.30.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.0.0 |
| <a name="requirement_kubernetes-alpha"></a> [kubernetes-alpha](#requirement\_kubernetes-alpha) | 0.2.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.30.0 |
| <a name="provider_external"></a> [external](#provider\_external) | n/a |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ebs_volume.prometheus](https://registry.terraform.io/providers/hashicorp/aws/3.30.0/docs/resources/ebs_volume) | resource |
| [kubernetes_cluster_role.prometheus](https://registry.terraform.io/providers/hashicorp/kubernetes/2.0.0/docs/resources/cluster_role) | resource |
| [kubernetes_cluster_role_binding.prometheus](https://registry.terraform.io/providers/hashicorp/kubernetes/2.0.0/docs/resources/cluster_role_binding) | resource |
| [kubernetes_config_map.global-config](https://registry.terraform.io/providers/hashicorp/kubernetes/2.0.0/docs/resources/config_map) | resource |
| [kubernetes_deployment.deployment](https://registry.terraform.io/providers/hashicorp/kubernetes/2.0.0/docs/resources/deployment) | resource |
| [kubernetes_ingress.ingress](https://registry.terraform.io/providers/hashicorp/kubernetes/2.0.0/docs/resources/ingress) | resource |
| [kubernetes_persistent_volume.prometheus](https://registry.terraform.io/providers/hashicorp/kubernetes/2.0.0/docs/resources/persistent_volume) | resource |
| [kubernetes_persistent_volume_claim.prometheus](https://registry.terraform.io/providers/hashicorp/kubernetes/2.0.0/docs/resources/persistent_volume_claim) | resource |
| [kubernetes_secret.auth](https://registry.terraform.io/providers/hashicorp/kubernetes/2.0.0/docs/resources/secret) | resource |
| [kubernetes_service.prometheus](https://registry.terraform.io/providers/hashicorp/kubernetes/2.0.0/docs/resources/service) | resource |
| [kubernetes_service_account.prometheus](https://registry.terraform.io/providers/hashicorp/kubernetes/2.0.0/docs/resources/service_account) | resource |
| [kubernetes_storage_class.expandable](https://registry.terraform.io/providers/hashicorp/kubernetes/2.0.0/docs/resources/storage_class) | resource |
| [external_external.htpasswd](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_resource_tags"></a> [aws\_resource\_tags](#input\_aws\_resource\_tags) | tags for resources created in AWS (i.e.: EBS volumes, etc.) | `map(string)` | `null` | no |
| <a name="input_external_labels"></a> [external\_labels](#input\_external\_labels) | labels to add to metrics when queried externally | `map(string)` | `null` | no |
| <a name="input_image"></a> [image](#input\_image) | https://github.com/prometheus/prometheus/releases | `string` | `"quay.io/prometheus/prometheus:v2.25.2"` | no |
| <a name="input_ingress_enabled"></a> [ingress\_enabled](#input\_ingress\_enabled) | if enabled creates an ingress mapping at /promtetheus (requires an ingress-controller) | `bool` | `false` | no |
| <a name="input_limit_cpu"></a> [limit\_cpu](#input\_limit\_cpu) | cpu limit | `string` | `"250m"` | no |
| <a name="input_limit_memory"></a> [limit\_memory](#input\_limit\_memory) | memory limit | `string` | `"250Mi"` | no |
| <a name="input_loadbalancer_enabled"></a> [loadbalancer\_enabled](#input\_loadbalancer\_enabled) | if enabled creates a LoadBalancer service to access the prometheus ui/api | `bool` | `false` | no |
| <a name="input_loadbalancer_internal"></a> [loadbalancer\_internal](#input\_loadbalancer\_internal) | if enabled creates a LoadBalancer service to access the prometheus ui/api | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | prometheus operated name | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | prometheus operated namespace | `string` | n/a | yes |
| <a name="input_node_selector"></a> [node\_selector](#input\_node\_selector) | labels to determine which node we run on | `map(string)` | `{}` | no |
| <a name="input_password"></a> [password](#input\_password) | username to login with (basic auth) | `string` | n/a | yes |
| <a name="input_replicas"></a> [replicas](#input\_replicas) | number of replicas | `number` | `1` | no |
| <a name="input_request_cpu"></a> [request\_cpu](#input\_request\_cpu) | requested cpu | `string` | `"200m"` | no |
| <a name="input_request_memory"></a> [request\_memory](#input\_request\_memory) | requested memory | `string` | `"200Mi"` | no |
| <a name="input_retention"></a> [retention](#input\_retention) | retention period (i.e.: 6h) | `string` | `"24h"` | no |
| <a name="input_s3_aws_access_key_id"></a> [s3\_aws\_access\_key\_id](#input\_s3\_aws\_access\_key\_id) | n/a | `string` | `""` | no |
| <a name="input_s3_aws_secret_access_key"></a> [s3\_aws\_secret\_access\_key](#input\_s3\_aws\_secret\_access\_key) | n/a | `string` | `""` | no |
| <a name="input_s3_bucket"></a> [s3\_bucket](#input\_s3\_bucket) | n/a | `string` | `""` | no |
| <a name="input_s3_endpoint"></a> [s3\_endpoint](#input\_s3\_endpoint) | n/a | `string` | `"s3.us-east-1.amazonaws.com"` | no |
| <a name="input_scrape_interval"></a> [scrape\_interval](#input\_scrape\_interval) | how often to scrape targets | `string` | `"10s"` | no |
| <a name="input_scrape_timeout"></a> [scrape\_timeout](#input\_scrape\_timeout) | how long to wait for a scrape to occur | `string` | `"5s"` | no |
| <a name="input_storage_gb"></a> [storage\_gb](#input\_storage\_gb) | storage amount for prometheus (minimum 20Gi for AWS) | `number` | `20` | no |
| <a name="input_thanos_loadbalancer_enabled"></a> [thanos\_loadbalancer\_enabled](#input\_thanos\_loadbalancer\_enabled) | if enabled creates a LoadBalancer service to access the (thanos) prometheus ui/api | `bool` | `false` | no |
| <a name="input_thanos_loadbalancer_internal"></a> [thanos\_loadbalancer\_internal](#input\_thanos\_loadbalancer\_internal) | if enabled creates a LoadBalancer service to access the (thanos) prometheus ui/api | `bool` | `false` | no |
| <a name="input_username"></a> [username](#input\_username) | username to login with (basic auth) | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
