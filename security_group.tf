resource "aws_security_group" "staging_sg" {
  name        = "${var.environment}_sg"
  description = "Allow http,ssh,icmp"
  vpc_id      = aws_vpc.staging_vpc.id


  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPs"
    from_port   = 443
    to_port     = 443
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
    description = "Postgresql Access to Retool"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["52.177.12.28/32", "52.175.251.223/32", "35.90.103.132/30", "44.208.168.68/30", "62.209.150.0/24", "178.124.194.0/24"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks =  ["0.0.0.0/0"]
  }
  
  tags = merge(
        {
            Name        = "${var.environment}_sg"
            Environment = "${var.environment}"
        },
        var.project_tags
    )
}