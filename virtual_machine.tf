#Creates the Azure VM
resource "azurerm_windows_virtual_machine" "vm-saa" {
  name                = "vm-dc"
  location            = azurerm_resource_group.rg-saa.location
  resource_group_name = azurerm_resource_group.rg-saa.name
  size                = "Standard_B2s"
  admin_username      = var.win_username
  admin_password      = var.win_userpass
  network_interface_ids = [
    azurerm_network_interface.nic-saa.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    #    sku       = "SQL-Server-2022-on-Windows-Server-2022"
    version = "latest"
  }
}

resource "azurerm_virtual_machine_extension" "install-iis" {
  name                 = "install-iis"
  virtual_machine_id   = azurerm_windows_virtual_machine.vm-saa.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.8"

  settings = <<SETTINGS
    { 
      "commandToExecute":"powershell Add-WindowsFeature Web-Server; powershell Add-Content -Path \"C:\\inetpub\\wwwroot\\Default.htm\" -Value $($env:computername)"
    } 
SETTINGS
}
