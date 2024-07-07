variable "region" {
    description = "AWS Region"
    type = string
    default = "ap-northeast-2"
}

variable "profile" {
    description = "AWS Configure Profile"
    type = string
}

variable "main_zone_id" {
  description = "AWS Route53 Main Zone ID"
  type        = string
}