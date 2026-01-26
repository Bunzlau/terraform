locals {
  ec2_name_z1 = "${var.environment}-${var.ec2_az1}"
  ec2_name_z2 = "${var.environment}-${var.ec2_az2}"

  common_tags_ec2 = {
    Project     = var.project_name
    Environment = var.environment
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.ami_name_filter]
  }

  filter {
    name   = "virtualization-type"
    values = [var.ami_virtualization]
  }

  owners = var.ami_owners // Owners for AMI lookup
}


resource "aws_instance" "ec2_az1" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.ec2_instance_type
  subnet_id     = var.subnet_id_public_az1
  # key_name = var.ec2_key_name
  vpc_security_group_ids = var.ec2_security_group_ids

  // Provide AZ-specific user data from template
  user_data = templatefile("${path.module}/user_data_az1.sh.tpl", {
    project_name = var.project_name
    environment  = var.environment
    az           = var.ec2_az1
    http_port    = var.http_port
  })

  // Only set key_name when provided

  tags = merge(local.common_tags_ec2, {
    Name = local.ec2_name_z1
  })
}

resource "aws_instance" "ec2_z2" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.ec2_instance_type
  subnet_id     = var.subnet_id_public_az2
  # key_name = var.ec2_key_name
  vpc_security_group_ids = var.ec2_security_group_ids

  user_data = templatefile("${path.module}/user_data_az2.sh.tpl", {
    project_name = var.project_name
    environment  = var.environment
    az           = var.ec2_az2
    http_port    = var.http_port
  })


  tags = {
    Name = local.ec2_name_z2
  }
}
