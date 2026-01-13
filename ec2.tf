locals {
  ec2_name = ${var.e}
}

//SG = tylko ALB + SSH
//PYTANIA do KODU: key_name - czy jest lepsza opcja
resource "aws_instance" "ec2_az1"{
ami = data.aws_ami.amazon_linux.id
instance_type = var.ec2_instance_type
subnet_id = aws_subnet.public_az1.id
key_name = var.ec2_key_name
vpc_security_group_ids = [
aws_security_group.ec2_sg.id
]

tags = {
Name = var.ec2_az1
}
}

resource "aws_instance" "ec2_z2"{
ami = data.aws_ami.amazon_linux.id
instance_type = var.ec2_instance_type
subnet_id = aws_subnet.public_az2.id
key_name = var.ec2_key_name
vpc_security_group_ids = [
aws_security_group.ec2_sg.id]
tags = {
Name = var.ec2_az2
}
}

