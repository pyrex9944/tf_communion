resource "aws_vpc" "staging_vpc" {
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

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.staging_vpc.id
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

# resource "aws_subnet" "private_subnet" {
#     vpc_id = aws_vpc.staging_vpc.id
#     cidr_block = "${var.public_subnets_cidr}"
#     availability_zone = "${var.availability_zone}"

#     tags = merge(
#         {
#             Name        = "${var.environment}_subnet_private"
#             Environment = "${var.environment}"
#         },
#         var.project_tags
#     )
# }

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.staging_vpc.id
  tags = merge(
        {
            Name        = "${var.environment}_igw"
            Environment = "${var.environment}"
        },
        var.project_tags
    )
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.staging_vpc.id


  route {
    cidr_block = var.rute_table_cidr
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = merge(
        {
            Name        = "${var.environment}_rt"
            Environment = "${var.environment}"
        },
        var.project_tags
    )
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}


resource "aws_eip" "staging_eip" {
  vpc      = true
  depends_on = [aws_internet_gateway.internet_gateway]
  
  tags = merge(
        {
            Name        = "${var.environment}_eip"
            Environment = "${var.environment}"
        },
        var.project_tags
    )
}