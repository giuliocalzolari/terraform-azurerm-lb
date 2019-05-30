data "azurerm_resource_group" "main" {
  name = "${var.resource_group}"
}

resource "azurerm_public_ip" "public_ip" {
  count               = "${var.lb_type == "public" ? 1 : 0}"
  name                = "${var.cluster_name}-${var.environment}-${var.name_suffix}-pip"
  location            = "${data.azurerm_resource_group.main.location}"
  resource_group_name = "${data.azurerm_resource_group.main.name}"
  allocation_method   = "Static"
}

resource "azurerm_lb" "load_balancer" {
  name                = "${var.cluster_name}-${var.environment}-${var.lb_type}-${var.name_suffix}-lb"
  location            = "${data.azurerm_resource_group.main.location}"
  resource_group_name = "${data.azurerm_resource_group.main.name}"

  frontend_ip_configuration {
    name                          = "${var.cluster_name}-${var.environment}-${var.lb_type}-${var.name_suffix}-frontend"
    public_ip_address_id          = "${var.lb_type == "public" ? join("",azurerm_public_ip.public_ip.*.id) : ""}"
    subnet_id                     = "${var.subnet_id}"
    private_ip_address_allocation = "${var.frontend_private_ip_address_allocation}"
    private_ip_address            = "${var.frontend_private_ip_address_allocation == "Static" ? var.frontend_private_ip_address : ""}"
  }
}

resource "azurerm_lb_backend_address_pool" "address_pool" {
  name                = "${var.cluster_name}-${var.environment}-${var.lb_type}-${var.name_suffix}-workers"
  resource_group_name = "${data.azurerm_resource_group.main.name}"
  loadbalancer_id     = "${azurerm_lb.load_balancer.id}"
}

resource "azurerm_lb_probe" "lb_probe" {
  count               = "${length(var.lb_ports)}"
  resource_group_name = "${data.azurerm_resource_group.main.name}"
  loadbalancer_id     = "${azurerm_lb.load_balancer.id}"
  name                = "${element(keys(var.lb_ports), count.index)}"
  protocol            = "Tcp"
  port                = "${element(var.lb_ports["${element(keys(var.lb_ports), count.index)}"], 2)}"
  interval_in_seconds = "${var.lb_probe_interval}"
  number_of_probes    = "${var.lb_probe_unhealthy_threshold}"
  request_path        = "${element(var.lb_ports["${element(keys(var.lb_ports), count.index)}"], 3)}"
}

resource "azurerm_lb_rule" "lb_rule" {
  count                          = "${length(var.lb_ports)}"
  resource_group_name            = "${data.azurerm_resource_group.main.name}"
  loadbalancer_id                = "${azurerm_lb.load_balancer.id}"
  name                           = "${element(keys(var.lb_ports), count.index)}"
  protocol                       = "${element(var.lb_ports["${element(keys(var.lb_ports), count.index)}"], 1)}"
  frontend_port                  = "${element(var.lb_ports["${element(keys(var.lb_ports), count.index)}"], 0)}"
  backend_port                   = "${element(var.lb_ports["${element(keys(var.lb_ports), count.index)}"], 2)}"
  frontend_ip_configuration_name = "${var.cluster_name}-${var.environment}-${var.lb_type}-${var.name_suffix}-frontend"
  enable_floating_ip             = false
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.address_pool.id}"
  idle_timeout_in_minutes        = 5
  probe_id                       = "${element(azurerm_lb_probe.lb_probe.*.id,count.index)}"
  depends_on                     = ["azurerm_lb_probe.lb_probe"]
}
