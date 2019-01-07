output "load_balancer_ip" {
  value = "${azurerm_public_ip.public_ip.*.ip_address}"
}

output "lb_address_pool_id" {
  value = "${azurerm_lb_backend_address_pool.address_pool.id}"
}
