data "aws_subnet" "public_subnet_details" {
  for_each = { for id in var.public_subnet_ids : id => id }
  id = each.value
}

resource "aws_eip" "this" {
  for_each = { for id in var.public_subnet_ids : id => id }

  domain = "vpc"

  tags = merge(
    var.tags,
    {
      Name = "eip-${each.key}-${data.aws_subnet.public_subnet_details[each.key].availability_zone}"
    }
  )
}