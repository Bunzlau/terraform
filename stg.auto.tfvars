region = "eu-west-1"

vpc_name           = "stg-vpc"
vpc_cidr           = "10.0.0.0/16"
internet_gateway   = "stg-igw"
public_route_table = "stg-public-rt"

default_route_cidr = "0.0.0.0/0"

public_subnet_az1_name = "stg-public-subnet-az1"
public_subnet_az1_cidr = "10.0.1.0/24"
public_subnet_az1_az   = "eu-west-1a"

public_subnet_az2_name = "stg-public-subnet-az2"
public_subnet_az2_cidr = "10.0.2.0/24"
public_subnet_az2_az   = "eu-west-1b"

ec2_az1           = "stg-ec2-instance-az1"
ec2_az2           = "stg-ec2-instance-az2"
ec2_instance_type = "t3.micro"
ec2_key_name      = "ha-key"
ec2_security_group = "stg-ec2-sg"

alb_name            = "stg-ha-lb"
alb_security_group  = "stg-alb-sg"
tg_name             = "stg-lb-tg"
tg                  = "stg-alb-target-group"
target_group_name   = "stg-tg"

http_port = 80
http_port_string = "80"
https_port = 443
https_port_string = "443"
ssh_port = 22
ssh_port_string = "22"

map_public_ip_on_launch = true
ingress_cidrs = ["0.0.0.0/0"]
egress_cidrs = ["0.0.0.0/0"]
ssh_allowed_cidrs = ["0.0.0.0/0"]
ami_name_filter = "amzn2-ami-hvm-*-x86_64-gp2"
ami_virtualization = "hvm"
ami_owners = ["amazon"]
alb_type = "application"
alb_internal = false
health_check_path = "/"
alb_protocol = "HTTP"