data "azurerm_resource_group" "this" {
  name = "rg_assignment"
}

resource "azurerm_kubernetes_cluster" "this" {
  name                = "aksassignment"
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name
  dns_prefix          = "aksassignment"
  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "standard_b2ms"
  }

  identity {
    type = "SystemAssigned"
  }
}