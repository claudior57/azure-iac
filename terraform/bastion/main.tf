# Create bastion host VM.

resource "azurerm_public_ip" "bastion-host-ip" {
  name                = "${var.enviroment}-ip"
  location            = data.terraform_remote_state.rg.outputs.rg_location
  resource_group_name = data.terraform_remote_state.rg.outputs.rg_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_network_interface" "bastion-vm-nic" {
  name                = "${var.enviroment}-bastion-01-nic"
  location            = data.terraform_remote_state.rg.outputs.rg_location
  resource_group_name = data.terraform_remote_state.rg.outputs.rg_name

  ip_configuration {
    name                          = "bastion-configuration1"
    subnet_id                     = data.terraform_remote_state.vnet.outputs.public_subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.bastion-host-ip.id
  }
}

resource "azurerm_virtual_machine" "bastion-vm" {
  name                  = "${var.enviroment}-bastion-01"
  location              = data.terraform_remote_state.rg.outputs.rg_location
  resource_group_name   = data.terraform_remote_state.rg.outputs.rg_name
  network_interface_ids = [azurerm_network_interface.bastion-vm-nic.id]
  vm_size               = "Standard_DS1_v2"

  storage_os_disk {
    name              = "${var.enviroment}-bastion-dsk001"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "${var.enviroment}-bastion-01"
    admin_username = var.username
    custom_data    = file("${path.module}/files/nginx.yml")
  }

  os_profile_linux_config {
    disable_password_authentication = true
    # Bastion host VM public key.
    ssh_keys {
      path     = "/home/${var.username}/.ssh/authorized_keys"
      key_data = file(var.ssh_public_key)
    }
  }
  //
  //  boot_diagnostics {
  //    enabled = "true"
  //    storage_uri = "${azurerm_storage_account.storage_account.primary_blob_endpoint}"
  //  }

  tags = var.tags
}

resource "azurerm_virtual_machine_extension" "bastion-ad" {
  name                 = "bastion-AADLoginForLinux"
  virtual_machine_id   = azurerm_virtual_machine.bastion-vm.id
  publisher            = "Microsoft.Azure.ActiveDirectory.LinuxSSH"
  type                 = "AADLoginForLinux"
  type_handler_version = "1.0"

  tags = var.tags
}

resource "azurerm_virtual_machine_extension" "bastion-initial-config" {
  name                 = "bastion-initial-config"
  virtual_machine_id   = azurerm_virtual_machine.bastion-vm.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"
  // this script is the base64 from the files/bastion_01.sh, and was generated using the command 'cat files/bastion_01.sh| base64 -w0 >script'
  // we gonna need to modify it later on
  settings = <<SETTINGS
    {
        "script": "IyEvYmluL3NoCgplY2hvICJNb2RpZnlpbmcgdGhlIFN1ZG9lcnMgZmlsZSIKCnN1ZG8gcm0gL2V0Yy9zdWRvZXJzLmQvYWFkX2FkbWlucwplY2hvICclYWFkX2FkbWlucyBBTEw9KEFMTCkgTk9QQVNTV0Q6QUxMJyA+IC9ldGMvc3Vkb2Vycy5kL2FhZF9hZG1pbnMKCmVjaG8gIkluc3RhbGxpbmcgQVogQ0xJIgpjdXJsIC1zTCBodHRwczovL2FrYS5tcy9JbnN0YWxsQXp1cmVDTElEZWIgfCBzdWRvIGJhc2gKCmVjaG8gIkluc3RhbGxpbmcgVG9vbHMiCm1rZGlyIGRvd25sb2FkcwpjZCAuL2Rvd25sb2FkcwoKZWNobyAiSW5zdGFsbGluZyBLdWJlY3RsIgpjdXJsIC1MTyAiaHR0cHM6Ly9zdG9yYWdlLmdvb2dsZWFwaXMuY29tL2t1YmVybmV0ZXMtcmVsZWFzZS9yZWxlYXNlLyQoY3VybCAtcyBodHRwczovL3N0b3JhZ2UuZ29vZ2xlYXBpcy5jb20va3ViZXJuZXRlcy1yZWxlYXNlL3JlbGVhc2Uvc3RhYmxlLnR4dCkvYmluL2xpbnV4L2FtZDY0L2t1YmVjdGwiCnN1ZG8gY2htb2QgK3gga3ViZWN0bApzdWRvIG12IC4va3ViZWN0bCAvdXNyL2Jpbi8KCmVjaG8gIkluc3RhbGxpbmcgSGVsbTMiCndnZXQgLU8gaGVsbS50YXIuZ3ogaHR0cHM6Ly9nZXQuaGVsbS5zaC9oZWxtLXYzLjIuNC1saW51eC1hbWQ2NC50YXIuZ3oKdGFyIC12enhmIGhlbG0udGFyLmd6CmNkIGxpbnV4LWFtZDY0CnN1ZG8gY2htb2QgK3ggaGVsbQpzdWRvIG12IC4vaGVsbSAvdXNyL2Jpbi8KY2QgLi4KCmVjaG8gIkluc3RhbGxpbmcgSzlzIgp3Z2V0IC1PIGs5cy50YXIuZ3ogaHR0cHM6Ly9naXRodWIuY29tL2RlcmFpbGVkL2s5cy9yZWxlYXNlcy9kb3dubG9hZC92MC4yMS43L2s5c19MaW51eF94ODZfNjQudGFyLmd6CnRhciAtdnp4ZiBrOXMudGFyLmd6CnN1ZG8gY2htb2QgK3ggazlzCnN1ZG8gbXYgLi9rOXMgL3Vzci9iaW4vCgplY2hvICJJbnN0YWxsaW5nIEhlbG1maWxlIgp3Z2V0IC1PIGhlbG1maWxlIGh0dHBzOi8vZ2l0aHViLmNvbS9yb2JvbGwvaGVsbWZpbGUvcmVsZWFzZXMvZG93bmxvYWQvdjAuMTI1LjIvaGVsbWZpbGVfbGludXhfYW1kNjQKc3VkbyBjaG1vZCAreCBoZWxtZmlsZQpzdWRvIG12IC4vaGVsbWZpbGUgL3Vzci9iaW4vCgplY2hvICJjbGVhbmluZyBzdHVmZiIKY2QgLi4Kc3VkbyBybSAtciBkb3dubG9hZHMK"
    }
SETTINGS
  tags     = var.tags
}