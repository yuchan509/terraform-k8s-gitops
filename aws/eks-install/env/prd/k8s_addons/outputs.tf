output "configure_kubectl" {
  description = "Configure kubectl: make sure you're logged in with the correct AWS profile and run the following command to update your kubeconfig"
  value       = "aws eks --region ${module.vars.region} update-kubeconfig --name ${module.vars.cluster_name} --profile ${module.vars.profile}"
}