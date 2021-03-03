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
  vpc_id                          = aws_vpc.vpc.id
  cidr_block                      = "10.0.1.0/24"
  availability_zone               = "us-west-2a"
  map_public_ip_on_launch         = true
  tags = {
    Name = "my-public-subnet"
  }
}
resource "aws_subnet" "private-subnet" {
  vpc_id                          = aws_vpc.vpc.id
  cidr_block                      = "10.0.2.0/24"
  availability_zone               = "us-west-2b"
  tags = {
    Name = "my-private-subnet"
  }
}
