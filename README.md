# Azure Load Balancer Module

This module create all required resources for deploy a load balancer to be used in Kubernetes Cluster.

## Usage

```bash
module "az_lb" {
  source = "https://github.com/walmartdigital/k8s-lb-module.git?ref=0.0.1"

  resource_group = "my-resource-group"
  cluster_name = "my-cluster-name"
  environment = "staging"
  name_suffix = "abc123"

  lb_port = {
    http  = ["80", "Tcp", "80"]
    https = ["443", "Tcp", "443"]
  }
}
```

## Arguments

* **resource_group**: Resource group where all resources will be provisioned (type: string, required).
* **cluster_name**: Name of the cluster (type: string, default: kubernetes).
* **environment**: Environment where the cluster is deployed (type: string, default: labs).
* **name_suffix**: A string used as name suffix (type: string).
* **lb_port**: A map used to provide the load balancer rules, each item is a key/value object, and the value is a list with the following variables: frontend_port, protocol, backend_port.

## Outputs

* **load_balancer_ip**: The load balancer public IP.
* **lb_address_pool_id**: The load balancer pool ID.