output "eks_cluster_arn" {
  description = "ARN of the EKS cluster managed by the tenant's infrastructure (if it exists)."
  value       = data.duplocloud_infrastructure.this.enable_k8_cluster ? one(data.aws_eks_cluster.this).arn : null
}

output "eks_cluster_name" {
  description = "Name of the EKS cluster managed by the tenant's infrastructure (if it exists)."
  value       = data.duplocloud_infrastructure.this.enable_k8_cluster ? one(data.aws_eks_cluster.this).name : null
}

output "eks_cluster_version" {
  description = "Version of the EKS cluster managed by the tenant's infrastructure (if it exists)."
  value       = data.duplocloud_infrastructure.this.enable_k8_cluster ? one(data.aws_eks_cluster.this).version : null
}

output "kubernetes_namespace" {
  description = "Name of the Kubernetes namespace where the tenant manages resources (if it exists)."
  value       = data.duplocloud_infrastructure.this.enable_k8_cluster ? "duploservices-${data.duplocloud_tenant.this.name}" : null
}
