data "azurerm_resource_group" "main" {
  name = "${var.resource_group}"
}

resource "azurerm_public_ip" "public_ip" {
  name                         = "${var.cluster_name}-${var.environment}-${var.name_suffix}-pip"
  location                     = "${data.azurerm_resource_group.main.location}"
  resource_group_name          = "${data.azurerm_resource_group.main.name}"
  public_ip_address_allocation = "static"
}

resource "azurerm_lb" "load_balancer" {
  name                = "${var.cluster_name}-${var.environment}-${var.name_suffix}-lb"
  location            = "${data.azurerm_resource_group.main.location}"
  resource_group_name = "${data.azurerm_resource_group.main.name}"

  frontend_ip_configuration {
    name                 = "${azurerm_public_ip.public_ip.name}"
    public_ip_address_id = "${azurerm_public_ip.public_ip.id}"
  }
}

resource "azurerm_lb_backend_address_pool" "address_pool" {
  name                = "${var.cluster_name}-${var.environment}-${var.name_suffix}-workers"
  resource_group_name = "${data.azurerm_resource_group.main.name}"
  loadbalancer_id     = "${azurerm_lb.load_balancer.id}"
}

resource "azurerm_lb_probe" "lb_probe" {
  name                = "${var.cluster_name}-${var.environment}-${var.name_suffix}-lb-probe"
  resource_group_name = "${data.azurerm_resource_group.main.name}"
  loadbalancer_id     = "${azurerm_lb.load_balancer.id}"
  protocol            = "http"
  request_path        = "${var.lb_probe_request_path}"
  port                = "${var.lb_probe_port}"
  interval_in_seconds = 15
}

resource "azurerm_lb_rule" "lb_rule_http" {
  name                           = "${var.cluster_name}-${var.environment}-${var.name_suffix}-lb-rule-http"
  resource_group_name            = "${data.azurerm_resource_group.main.name}"
  loadbalancer_id                = "${azurerm_lb.load_balancer.id}"
  protocol                       = "tcp"
  frontend_port                  = 80
  backend_port                   = "${var.lb_rule_port_http}"
  frontend_ip_configuration_name = "${azurerm_public_ip.public_ip.name}"
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.address_pool.id}"
  probe_id                       = "${azurerm_lb_probe.lb_probe.id}"
}

resource "azurerm_lb_rule" "lb_rule_https" {
  name                           = "${var.cluster_name}-${var.environment}-${var.name_suffix}-lb-rule-https"
  resource_group_name            = "${data.azurerm_resource_group.main.name}"
  loadbalancer_id                = "${azurerm_lb.load_balancer.id}"
  protocol                       = "tcp"
  frontend_port                  = 443
  backend_port                   = "${var.lb_rule_port_https}"
  frontend_ip_configuration_name = "${azurerm_public_ip.public_ip.name}"
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.address_pool.id}"
  probe_id                       = "${azurerm_lb_probe.lb_probe.id}"
}
