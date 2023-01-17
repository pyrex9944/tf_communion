resource "aws_vpc" "ownvpc" {
  cidr_block       = var.vpc_cidr
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
  cidr_block = "${var.private_subnets_cidr}"
  availability_zone = "${var.availability_zone}"

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
    cidr_block = "${var.public_subnets_cidr}"
    availability_zone = "${var.availability_zone}a"

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
    cidr_block = var.rute_table_cidr
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