resource "aws_instance" "communion" {
  ami           = "${var.ami}"
  instance_type = "${var.instance_type}"
  associate_public_ip_address = true
  subnet_id = aws_subnet.public.id
  vpc_security_group_ids = ["${aws_security_group.mywebsecurity.id}"]
  key_name = "staging_rsa_key"
  availability_zone = "${var.aws_region}a"

  root_block_device {
    volume_size = "${var.volume_size}"
    volume_type = "${var.volume_type}"
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