# Azure Load Balancer Module

This module create all required resources for deploy a load balancer to be used in Kubernetes Cluster.

## Usage

```bash
module "az_lb" {
  source = "https://github.com/walmartdigital/k8s-lb-module.git?ref=0.0.1"

  resource_group = "my-resource-group"
  cluster_name = "my-cluster-name"
  environment = "staging"
  lb_probe_port = "30000"
  lb_rule_port_http = "30001"
  lb_rule_port_https = "30002"

}
```

## Arguments

* **resource_group**: Resource group where all resources will be provisioned (type: string, required).
* **cluster_name**: Name of the cluster (type: string, default: kubernetes).
* **environment**: Environment where the cluster is deployed (type: string, default: labs).
* **lb_probe_port**: Port for being used for load balancer probe (type: string, required).
* **lb_rule_port_http**: HTTP port (type: string, required).
* **lb_rule_port_https**: HTTPS port (type: string, required).
