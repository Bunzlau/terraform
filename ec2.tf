locals {
    ec2_name_z1 = "${var.environment}-${var.ec2_az1}"
    ec2_name_z2 = "${var.environment}-${var.ec2_az2}"

    common_tags = {
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


resource "aws_instance" "ec2_az1"{
ami = data.aws_ami.amazon_linux.id
instance_type = var.ec2_instance_type
subnet_id = aws_subnet.public_az1.id
key_name = var.ec2_key_name
vpc_security_group_ids = [
aws_security_group.ec2_sg.id
]

tags = merge(local.common_tags, {
Name = local.ec2_name_z1
})
}

resource "aws_instance" "ec2_z2"{
ami = data.aws_ami.amazon_linux.id
instance_type = var.ec2_instance_type
subnet_id = aws_subnet.public_az2.id
key_name = var.ec2_key_name
vpc_security_group_ids = [
aws_security_group.ec2_sg.id]
tags = {
Name = local.ec2_name_z2
}
}

