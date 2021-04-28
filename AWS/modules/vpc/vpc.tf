/*==== The VPC ======*/
resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name        = "${var.env}-vpc"
    Environment = var.env
  }
}
/*==== Subnets ======*/
/* Internet gateway for the public subnet */
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name        = "${var.env}-igw"
    Environment = var.env
  }
}
/* Elastic IP for NAT */
resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.igw]
}
/* NAT */
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = element(aws_subnet.pub_net.*.id, 0)
  depends_on    = [aws_internet_gateway.igw]
  tags = {
    Name        = "${var.env}-natgw"
    Environment = var.env
  }
}
/* Public subnet */
resource "aws_subnet" "pub_net" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.pub_cidr_block)
  cidr_block              = element(var.pub_cidr_block, count.index)
  availability_zone       = element(var.az_zones, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name        = "${var.env}-pub-net"
    Environment = var.env
  }
}
/* Private subnet */
resource "aws_subnet" "pvt_net" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.pvt_cidr_block)
  cidr_block              = element(var.pvt_cidr_block, count.index)
  availability_zone       = element(var.az_zones, count.index)
  map_public_ip_on_launch = false
  tags = {
    Name        = "${var.env}-pvt-net"
    Environment = var.env
  }
}
/* Routing table for private subnet */
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name        = "${var.env}-pvt-rt-table"
    Environment = var.env
  }
}
/* Routing table for public subnet */
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name        = "${var.env}-pub-rt-table"
    Environment = var.env
  }
}
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}
resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}
/* Route table associations */
resource "aws_route_table_association" "public" {
  count          = length(var.pub_cidr_block)
  subnet_id      = element(aws_subnet.pub_net.*.id, count.index)
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "private" {
  count          = length(var.pvt_cidr_block)
  subnet_id      = element(aws_subnet.pvt_net.*.id, count.index)
  route_table_id = aws_route_table.private.id
}
