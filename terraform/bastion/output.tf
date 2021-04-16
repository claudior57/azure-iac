output "bastion_public_ip" {
  value = azurerm_public_ip.bastion-host-ip.ip_address
}

output "bastion_vm_id" {
  value = azurerm_virtual_machine.bastion-vm.id
}
