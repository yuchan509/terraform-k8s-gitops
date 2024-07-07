variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to the EIP resources"
  type        = map(string)
  default     = {}
}

