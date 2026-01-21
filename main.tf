module "vpc"
{
  source = "./modules/vpc"
  region = var.region
  vpc_name = var.vpc_name
  internet_gateway = var.internet_gateway
  vpc_cidr = var.vpc_cidr
  public_route_table = var.public_route_table
  public_subnet_az1_name = var.public_subnet_az1_name
  public_subnet_az1_cidr = var.public_subnet_az1_cidr
  public_subnet_az1_az = var.public_subnet_az1_az
  public_subnet_az2_name = var.public_subnet_az2_name
  public_subnet_az2_cidr = var.public_subnet_az2_cidr
  public_subnet_az2_az = var.public_subnet_az2_az
  map_public_ip_on_launch = var.map_public_ip_on_launch
  default_route_cidr = ""
  environment = ""
  project_name = ""
}

module "ec2" {
    source = "./modules/ec2"
    ec2_instance_type = var.ec2_instance_type
    environment = var.environment
    ec2_az1 = var.ec2_az1
    ec2_az2 = var.ec2_az2
    project_name = var.project_name
    ami_name_filter = var.ami_name_filter
    ami_virtualization = var.ami_virtualization
    ami_owners = var.ami_owners
    ec2_key_name = var.ec2_key_name
    subnet_id_public_az1 = module.vpc.public_subnet_az1_id
    subnet_id_public_az2 = module.vpc.public_subnet_az2_id
    ec2_security_group_ids = [module.sg.ec2_sg_id]
}

module "lb" {
    source = "./modules/lb"
    environment = var.environment
    project_name = var.project_name
    alb_name = var.alb_name
    tg_name = var.tg_name
    http_port = var.http_port
    http_port_string = var.http_port_string
    https_port = var.https_port
    https_port_string = var.https_port_string
    ssh_port = var.ssh_port
    ssh_port_string = var.ssh_port_string
    ingress_cidrs = var.ingress_cidrs
    egress_cidrs = var.egress_cidrs
    alb_type = var.alb_type
    alb_internal = var.alb_internal
    subnet_ids = [module.vpc.public_subnet_az1_id, module.vpc.public_subnet_az2_id]
    security_group_ids = [module.sg.alb_sg_id]
    alb_protocol = var.alb_protocol
    health_check_path = var.health_check_path
    target_group_name = var.target_group_name
    tg = var.tg
    vpc_id = module.vpc.vpc_id
}

module "sg" {

  source = "./modules/sg"
  alb_security_group = module.sg.alb_sg_id
  ec2_security_group = ""
  egress_cidrs = []
  environment = ""
  http_port = 0
  ingress_cidrs = []
  project_name = ""
  ssh_allowed_cidrs = []
  ssh_port = 0
  target_group_arn = ""
  target_instance_ids = []
  vpc_id = ""
}