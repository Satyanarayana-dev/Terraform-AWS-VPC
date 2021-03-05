provider "aws" {
  region = "us-west-2"
}
resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "my-VPC"
  }
}
resource "aws_subnet" "public-subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "my-public-subnet"
  }
}
resource "aws_subnet" "private-subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2b"
  tags = {
    Name = "my-private-subnet"
  }
}
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "my-ig"
  }
}
resource "aws_eip" "nat" {
  vpc              = true
}
resource "aws_nat_gateway" "nat-ig" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public-subnet.id
  tags = {
    Name = "my-nat-ig"
  }
}
resource "aws_route_table" "public-RT" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }
  tags = {
    Name = "my-public-rt"
  }
}
resource "aws_route_table" "private-RT" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-ig.id
  }
  tags = {
    Name = "my-private-rt"
  }
}
resource "aws_route_table_association" "public-rt-ass" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.public-RT.id
}
resource "aws_route_table_association" "private-rt-ass" {
  subnet_id      = aws_subnet.private-subnet.id
  route_table_id = aws_route_table.private-RT.id
}
