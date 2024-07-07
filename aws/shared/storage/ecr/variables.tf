variable "ecr_name" {
  description = "AWS ECR Private Name"
  type = string
}

variable "cnt_number" {
  description = "AWS ECR Repo Least Image Count"
  type = number
  default = 10
}

variable "tags" {
  description = "AWS ECR Tags"
  type = map(string)
}


