locals {
  vpc_cidr = distinct([ for v in var.networks : v.vpc_cidr ])
  vpc_name = distinct([ for v in var.networks : v.vpc_name ])
  availability_zone = {
    "ap-northeast-2a" = "A"
    "ap-northeast-2b" = "B"
    "ap-northeast-2c" = "C"
    "ap-northeast-2d" = "D"
  }

  test = { for k, v in var.networks : v.subnet_cidr => v if v.type == "public" }
}

resource "aws_vpc" "main" {
  cidr_block = local.vpc_cidr[0]
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "${local.vpc_name[0]}-vpc"
  }
}

resource "aws_subnet" "main" {
  for_each = var.networks

  vpc_id = aws_vpc.main.id
  cidr_block = each.value.subnet_cidr
  availability_zone = each.value.availability_zone
  map_public_ip_on_launch = each.value.type == "public" ? true : false

  tags = {
    Name = "${local.vpc_name[0]}-${each.value.type}-subnet-${lookup(local.availability_zone, each.value.availability_zone, "default")}"
  }
}

//igw
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${local.vpc_name[0]}-igw"
  }
}

//route table
resource "aws_route_table" "main" {
  for_each = var.networks

  vpc_id = aws_vpc.main.id

  route {
    cidr_block = aws_vpc.main.cidr_block
    gateway_id = "local"
  }

  dynamic "route" {
    for_each = { for k, v in var.networks : v.subnet_cidr => v if v.type == "public" && each.value.subnet_cidr == v.subnet_cidr }

    content {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.main.id
    }
  }

  tags = {
    Name = "${local.vpc_name[0]}-${each.value.type}-rtb-${lookup(local.availability_zone, each.value.availability_zone, "default")}"
  }
}

//route table association
resource "aws_route_table_association" "main" {
  for_each = var.networks

  subnet_id = aws_subnet.main[each.key].id
  route_table_id = aws_route_table.main[each.key].id
}