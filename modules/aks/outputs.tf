output "kubernetes_clusters" {
  description = "The full AKS objects"
  value       = azurerm_kubernetes_cluster.aks
  sensitive   = true # Contains kube_config which is sensitive
}
