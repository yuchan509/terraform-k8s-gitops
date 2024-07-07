#--------------------------------------------------------------------------------
# Load Balancer
#--------------------------------------------------------------------------------

output "id" {
  description = "The ID and ARN of the load balancer we created"
  value       = module.nlb.id
}

output "arn" {
  description = "The ID and ARN of the load balancer we created"
  value       = module.nlb.arn
}

output "arn_suffix" {
  description = "ARN suffix of our load balancer - can be used with CloudWatch"
  value       = module.nlb.arn_suffix
}

output "dns_name" {
  description = "The DNS name of the load balancer"
  value       = module.nlb.dns_name
}

output "zone_id" {
  description = "The zone_id of the load balancer to assist with creating DNS records"
  value       = module.nlb.zone_id
}

#--------------------------------------------------------------------------------
# Listener(s)
#--------------------------------------------------------------------------------

output "listeners" {
  description = "Map of listeners created and their attributes"
  value       = module.nlb.listeners
}

output "listener_rules" {
  description = "Map of listeners rules created and their attributes"
  value       = module.nlb.listener_rules
}

#--------------------------------------------------------------------------------
# Target Group(s)
#--------------------------------------------------------------------------------

output "target_groups" {
  value = {
    for k, v in module.nlb.target_groups : k => {
      arn  = v.arn
      port = v.port
    }
  }
}

#--------------------------------------------------------------------------------
# Security Group
#--------------------------------------------------------------------------------

output "security_group_arn" {
  description = "Amazon Resource Name (ARN) of the security group"
  value       = module.nlb.security_group_arn
}

output "security_group_id" {
  description = "ID of the security group"
  value       = module.nlb.security_group_id
}