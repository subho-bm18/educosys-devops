resource "aws_vpc" "subhodeep_vpc" {
  cidr_block = var.cidr
  tags = {
    Name        = var.name
    Environment = var.environment
    Billing     = var.billing
    Component   = var.component
  }
}

resource "aws_subnet" "internal_subnet" {
  count = length(var.internal_subnets)

  vpc_id            = aws_vpc.subhodeep_vpc.id
  cidr_block        = var.internal_subnets[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = {
    Name        = "${var.name}-internal-${count.index}"
    Environment = var.environment
  }
}

resource "aws_subnet" "external_subnet" {
  count = length(var.external_subnets)

  vpc_id            = aws_vpc.subhodeep_vpc.id
  cidr_block        = var.external_subnets[count.index]
  availability_zone = var.availability_zones[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name        = "${var.name}-external-${count.index}"
    Environment = var.environment
  }
}
