provider "aws" {
  region = "eu-central-1"
}

resource "aws_vpc" "ownvpc" {
  cidr_block       = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = merge(
        {
            Name        = "${var.environment}_vpc"
            Environment = "${var.environment}"
        },
        var.project_tags
    )
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.ownvpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "eu-central-1a"

  tags = merge(
        {
            Name        = "${var.environment}_subnet_public"
            Environment = "${var.environment}"
        },
        var.project_tags
    )
}

resource "aws_subnet" "private" {
    vpc_id = aws_vpc.ownvpc.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "eu-central-1a"

    tags = merge(
        {
            Name        = "${var.environment}_subnet_private"
            Environment = "${var.environment}"
        },
        var.project_tags
    )
}

resource "aws_internet_gateway" "mygw" {
  vpc_id = aws_vpc.ownvpc.id
  tags = merge(
        {
            Name        = "${var.environment}_internet_gateway"
            Environment = "${var.environment}"
        },
        var.project_tags
    )
}

resource "aws_route_table" "my_route_table1" {
  vpc_id = aws_vpc.ownvpc.id


  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mygw.id
  }

  tags = merge(
        {
            Name        = "${var.environment}_route_table"
            Environment = "${var.environment}"
        },
        var.project_tags
    )
}

resource "aws_route_table_association" "route_table_association1" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.my_route_table1.id
}


resource "aws_eip" "eip" {
  vpc      = true
  depends_on = [aws_internet_gateway.mygw,]
  
  tags = merge(
        {
            Name        = "${var.environment}-eip"
            Environment = "${var.environment}"
        },
        var.project_tags
    )
}


resource "aws_security_group" "mywebsecurity" {
  name        = "my_web_security"
  description = "Allow http,ssh,icmp"
  vpc_id      = aws_vpc.ownvpc.id


  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "ALL ICMP - IPv4"
    from_port   = -1    
    to_port     = -1
    protocol    = "ICMP"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks =  ["0.0.0.0/0"]
  }
  
  tags = merge(
        {
            Name        = "${var.environment}-sg"
            Environment = "${var.environment}"
        },
        var.project_tags
    )
}

resource "aws_instance" "communion" {
  ami           = "ami-0039da1f3917fa8e3"
  instance_type = "t2.micro"
  associate_public_ip_address = true
  subnet_id = aws_subnet.public.id
  vpc_security_group_ids = ["${aws_security_group.mywebsecurity.id}"]
  key_name = "staging_rsa_key"
  availability_zone = "eu-central-1a"

  root_block_device {
    volume_size = 20
    volume_type = "gp2"
    encrypted   = false
  }


  tags = merge(
        {
            Name        = "${var.environment}_instance"
            Environment = "${var.environment}"
        },
        var.project_tags
    )
}