resource "aws_instance" "communion" {
  ami           = "${var.ami}"
  instance_type = "${var.instance_type}"
  associate_public_ip_address = true
  subnet_id = aws_subnet.public.id
  vpc_security_group_ids = ["${aws_security_group.mywebsecurity.id}"]
  key_name = var.key_name
  availability_zone = "${var.availability_zone}"

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