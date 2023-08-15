resource "local_file" "kubeconfig" {
  depends_on = [azurerm_kubernetes_cluster.akc1]
  filename = "kubeconfig"
  content = azurerm_kubernetes_cluster.akc1.kube_config_raw
}

# This is an example of specifying output to be displayed in the terminal:
# output "instance_id" {
#     description = "id of created VM instance."
#     value       = azurerm_linux_virtual_machine.main.id
# }
