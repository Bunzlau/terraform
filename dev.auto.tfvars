region = "eu-west-1"

vpc_name           = "dev-vpc"
vpc_cidr           = "10.0.0.0/16"
internet_gateway   = "dev-igw"
public_route_table = "dev-public-rt"

public_subnet_az1_name = "dev-public-subnet-az1"
public_subnet_az1_cidr = "10.0.1.0/24"
public_subnet_az1_az   = "eu-west-1a"

public_subnet_az2_name = "dev-public-subnet-az2"
public_subnet_az2_cidr = "10.0.2.0/24"
public_subnet_az2_az   = "eu-west-1b"

ec2_az1           = "dev-ec2-instance-az1"
ec2_az2           = "dev-ec2-instance-az2"
ec2_instance_type = "t3.micro"
ec2_key_name      = "ha-key"
ec2_security_group = "dev-ec2-sg"

alb_name            = "dev-ha-lb"
alb_security_group  = "dev-alb-sg"
tg_name             = "dev-lb-tg"
tg                  = "dev-alb-target-group"

http_port = 80
http_port_string = "80"
https_port = 443
https_port_string = "443"
ssh_port = 22
ssh_port_string = "22"