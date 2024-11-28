resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "${var.prefix}-vpc"
  }
}

data "aws_availability_zones" "available" {}

resource "aws_subnet" "subnets" {
  count                   = 2
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.${count.index}.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.prefix}-subnet-${count.index}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.prefix}-igw"
  }
}

resource "aws_route_table" "rtbl" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.prefix}-rtbl"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rtbl-association" {
  count          = 2
  route_table_id = aws_route_table.rtbl.id
  subnet_id = aws_subnet.subnets.*.id[count.index]
}

# resource "aws_subnet" "fiap-tech-challenge-subnet-1" {
#   availability_zone = "us-east-1a"
#   vpc_id            = aws_vpc.main.id
#   cidr_block        = "10.0.0.0/24"

#   tags = {
#     Name = "${var.prefix}-subnet-1"
#   }
# }

# resource "aws_subnet" "fiap-tech-challenge-subnet-2" {
#   availability_zone = "us-east-1a"
#   vpc_id            = aws_vpc.main.id
#   cidr_block        = "10.0.1.0/24"

#   tags = {
#     Name = "${var.prefix}-subnet-2"
#   }
# }
