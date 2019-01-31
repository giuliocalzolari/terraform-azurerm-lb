# Azure Load Balancer Module

This module create all required resources for deploy a public or private load balancer on Azure.

## Usage

### Create a public load balancer

```bash
module "az_lb" {
  source = "https://github.com/walmartdigital/k8s-lb-module.git?ref=0.0.2"

  resource_group = "my-resource-group"
  cluster_name   = "my-cluster-name"
  environment    = "staging"
  name_suffix    = "abc123"

  lb_ports = {
    http  = ["80", "Tcp", "80"]
    https = ["443", "Tcp", "443"]
  }
}
```

### Create a private load balancer

```bash
module "az_lb" {
  source = "git::https://github.com/walmartdigital/k8s-lb-module.git?ref=0.0.2"

  resource_group                         = "my-resource-group"
  cluster_name                           = "my-cluster-name"
  environment                            = "staging"
  name_suffix                            = "abc123"
  lb_type                                = "private"
  frontend_subnet_id                     = "subnet-id"
  frontend_private_ip_address_allocation = "Static"
  frontend_private_ip_address            = "10.20.0.2"

  lb_ports = {
    http  = ["80", "Tcp", "80"]
    https = ["443", "Tcp", "443"]
    dns   = ["53", "Tcp", "53"]
  }
}
```

## Arguments

* **resource_group**: A string representing the resource group where all resources will be provisioned, this resource group needs to be previously created (required).
* **cluster_name**: A string used as the cluster name.
* **environment**: A string used as environment where the cluster is deployed.
* **name_suffix**: A string used as name suffix.
* **lb_type**: A string used as the load balancer type. Default is public. If the load balancer type is private, you need to provide the following string variables: _frontend_subnet_id_, _frontend_private_ip_address_allocation_ and _frontend_private_ip_address_.
* **lb_port**: A map used to provide the load balancer rules, each item is a key/value object, and the value is a list with the following variables: _frontend_port_, _protocol_, _backend_port_.

## Outputs

* **load_balancer_ip**: The load balancer public IP.
* **lb_address_pool_id**: The load balancer pool ID.