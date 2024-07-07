output "allocation_ids" {
  description = "ID that AWS assigns to represent the allocation of the Elastic IP address for use with instances in a VPC."
  value = { for k, eip in aws_eip.this : k => eip.allocation_id }
}

output "association_ids" {
  description = "ID representing the association of the address with an instance in a VPC."
  value = { for k, eip in aws_eip.this : k => eip.association_id }
}

output "carrier_ips" {
  description = "Carrier IP address."
  value = { for k, eip in aws_eip.this : k => eip.carrier_ip }
}

output "customer_owned_ips" {
  description = "Customer owned IP."
  value = { for k, eip in aws_eip.this : k => eip.customer_owned_ip }
}

output "eip_ids" {
  description = "Contains the EIP allocation ID."
  value = { for k, eip in aws_eip.this : k => eip.id }
}

output "private_dns" {
  description = "The Private DNS associated with the Elastic IP address (if in VPC)."
  value = { for k, eip in aws_eip.this : k => eip.private_dns }
}

output "private_ips" {
  description = "Contains the private IP address (if in VPC)."
  value = { for k, eip in aws_eip.this : k => eip.private_ip }
}

output "ptr_records" {
  description = "The DNS pointer (PTR) record for the IP address."
  value = { for k, eip in aws_eip.this : k => eip.ptr_record }
}

output "public_dns" {
  description = "Public DNS associated with the Elastic IP address."
  value = { for k, eip in aws_eip.this : k => eip.public_dns }
}

output "public_ips" {
  description = "Contains the public IP address."
  value = { for k, eip in aws_eip.this : k => eip.public_ip }
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value = { for k, eip in aws_eip.this : k => eip.tags_all }
}
