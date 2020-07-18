
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}-vnet"
  address_space       = var.vnet-addspace
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.common_tags

}

resource "azurerm_subnet" "subnet" {
  name                 = "${var.prefix}-subnet"
  address_prefix       = var.subnet-addprefix
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.rg.name

}

resource "azurerm_network_interface" "vmnic" {

  count = var.servercount
  #name                = "${var.prefix}-vmnic"
  name                = "${var.prefix}-${format("%02d", count.index)}-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.common_tags


  ip_configuration {
    name                          = "${var.prefix}-vmip"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    #public_ip_address_id          = [element(azurerm_public_ip.pip.*.id, count.index)]
    #public_ip_address_id = "${length(azurerm_public_ip.pip.*.id) > 0 ? element(concat(azurerm_public_ip.pip.*.id, list("")), count.index) : ""}"
    public_ip_address_id = length(azurerm_public_ip.pip.*.id) > 0 ? element(concat(azurerm_public_ip.pip.*.id, list("")), count.index) : ""


  }

}

resource "azurerm_public_ip" "pip" {
  #count = var.istest == true ? var.servercount : 0
  count = var.servercount
  name                = "${var.prefix}-${format("%02d", count.index)}-pip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  tags                = local.common_tags

}


output "IPaddress" {
  value = azurerm_public_ip.pip[*].ip_address

}