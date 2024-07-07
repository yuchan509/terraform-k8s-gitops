module "ecr" {
    source = "terraform-aws-modules/ecr/aws"
    
    repository_type = "private"
    repository_name = var.ecr_name

    repository_image_tag_mutability = "MUTABLE"
   
    repository_lifecycle_policy = jsonencode({
    rules = [
        {
        rulePriority = 1,
        description  = "Keep last ${var.cnt_number} images",
        selection = {
            tagStatus     = "any",
            countType     = "imageCountMoreThan",
            countNumber   = var.cnt_number
        },
        action = {
            type = "expire"
        }
        }
    ]
    })

    tags = merge(var.tags, {
        "name" = var.ecr_name
    })
}