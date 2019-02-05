# Azure Load Balancer Module

This module create all required resources for deploy a public or private load balancer on Azure.

## Usage

### Create a public load balancer

```bash
module "az_lb" {
  source = "git::https://github.com/walmartdigital/k8s-lb-module.git?ref=0.1.0"

  resource_group = "my-resource-group"
  cluster_name   = "my-cluster-name"
  environment    = "staging"
  name_suffix    = "abc123"

  lb_ports = {
    http  = ["80", "Tcp", "80", "80"]
    https = ["443", "Tcp", "443", "443"]
  }
}
```

### Create a private load balancer

```bash
module "az_lb" {
  source = "git::https://github.com/walmartdigital/k8s-lb-module.git?ref=0.1.0"

  resource_group                         = "my-resource-group"
  cluster_name                           = "my-cluster-name"
  environment                            = "staging"
  name_suffix                            = "abc123"
  lb_type                                = "private"
  subnet_id                              = "subnet-id"

  lb_ports = {
    http  = ["80", "Tcp", "80", "80"]
    https = ["443", "Tcp", "443", "443"]
    dns   = ["53", "Udp", "53", "55"]
  }
}
```

## Arguments

* **resource_group**: A string representing the resource group where all resources will be provisioned, this resource group needs to be previously created (required).
* **cluster_name**: A string used as the cluster name.
* **environment**: A string used as environment where the cluster is deployed.
* **name_suffix**: A string used as name suffix.
* **lb_type**: A string used as the load balancer type. Default is public. If the load balancer type is private, you need to provide the following string variables: _subnet_id_ (required), _frontend_private_ip_address_allocation_ (optional) and _frontend_private_ip_address_ (optional).
* **lb_ports**: A map used to provide the load balancer rules, each item is a key/value object, and the value is a list with the following variables: _frontend_port_, _protocol_, _backend_port_, _probe_port_.

## Outputs

* **load_balancer_public_ip**: The load balancer public IP.
* **load_balancer_private_ip**: The load balancer private IP.
* **lb_address_pool_id**: The load balancer address pool ID.