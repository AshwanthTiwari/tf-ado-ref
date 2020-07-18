
resource "azurerm_windows_virtual_machine" "vm" {
  count = var.servercount
  name  = "${var.prefix}-${format("%02d", count.index)}-vm"
  #name                  = "${var.prefix}-vm"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.vmnic[count.index].id]
  ##fromMS**network_interface_ids = [element(azurerm_network_interface.vmnic.*.id, count.index)]
  #size                  = var.vmsize
  size           = var.typeexample["australiaeast"]
  admin_username = var.adminuser
  admin_password = var.adminpass
  tags           = local.common_tags

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"

  }

}

output "vmname" {
value = azurerm_windows_virtual_machine.vm[*].name

}
