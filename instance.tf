resource "aws_instance" "jenkins_instance" {
  for_each = {for instance in var.jenkins_instance_values : instance.name => instance}

  ami             = var.ami
  instance_type   = var.instance_type
  subnet_id       = module.vpc.public_subnet_id[0]
  key_name        = var.instance_key_name
  security_groups = [aws_security_group.instance_sg.id]

  user_data = base64encode(templatefile("${path.module}/${each.value.master ? "master-instance.tpl" : "slave-instance.tpl"}", {
    efs_mount_point = each.value.efs_mount_point
    file_system_id  = aws_efs_file_system.efs_file_system.id
    name            = each.value.name
  }))

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  tags = merge(local.tags, {
    "Name" = each.key
  })

  lifecycle {
    ignore_changes = [
      /*security_groups*/
    ]
  }
}

resource "aws_eip" "instance_eip" {
  for_each = aws_instance.jenkins_instance

  vpc      = true
  instance = each.value.id

  depends_on = [aws_instance.jenkins_instance]
}

resource "aws_security_group" "instance_sg" {
  name        = "instance security group"
  description = "port 22 allow traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr, "0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.tags
}
