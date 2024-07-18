provider "aws" {
  region = "ap-northeast-2"
}

variable "instance_count" {
  default = 2
}

variable "instance_type" {
  default = "t2.micro"
}

resource "aws_vpc" "main" {
  cidr_block = "192.168.0.0/16"

  tags = {
    Name = "main-vpc"
  }
}

resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "192.168.1.0/24"
  availability_zone = "ap-northeast-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "main-subnet"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "main-route-table"
  }
}

resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}

resource "aws_security_group" "main" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "main-sg"
  }
}

resource "aws_instance" "web" {
  count         = var.instance_count
  ami           = "ami-04ea5b2d3c8ceccf8"
  instance_type = var.instance_type
  key_name      = "uno-key"
  subnet_id     = aws_subnet.main.id
  vpc_security_group_ids = [aws_security_group.main.id]

  tags = {
    Name = "WebServer-${count.index}"
  }
}

output "instance_ips" {
  value = aws_instance.web.*.public_ip
}
