resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = var.internet_gateway
  }
}
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.default_route_cidr
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = var.public_route_table
  }
}

resource "aws_subnet" "public_az1" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.public_subnet_az1_cidr
  availability_zone = var.public_subnet_az1_az
  // potrzebne do automatycznego przypisywania publicznych IP do instancji w tym subnecie
  map_public_ip_on_launch = var.map_public_ip_on_launch

    tags = {
    Name = var.public_subnet_az1_name
  }
}

resource "aws_subnet" "public_az2" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.public_subnet_az2_cidr
  availability_zone = var.public_subnet_az2_az
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = {
    Name = var.public_subnet_az2_name
  }
}

resource "aws_route_table_association" "az1" {
  route_table_id = aws_route_table.public.id
    subnet_id      = aws_subnet.public_az1.id
}

resource "aws_route_table_association" "az2" {
  route_table_id = aws_route_table.public.id
    subnet_id      = aws_subnet.public_az2.id
}

resource "aws_security_group" "alb_sg" {
  name        =  var.alb_security_group
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP from anywhere"
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = "tcp"
    cidr_blocks = var.ingress_cidrs
  }
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = var.egress_cidrs
  }
}

resource "aws_security_group" "ec2_sg" {
  name        =  var.ec2_security_group
  description = "Allow traffic from ALB"
  vpc_id      = aws_vpc.main.id

  // mo?na definiowa? wiele ingress blok�w. Dobre praktyki, to mie? osobny blok na ka?dy typ ruchu np HTTP, SSH itp.
  ingress {
    description = "HTTP from ALB"
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    description = "SSH from Your IP"
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = var.ssh_allowed_cidrs
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = var.egress_cidrs

  }
}

//pobieramy najnowszy Amazon Linux 2 AMI w regionie
//znajdzie najnowsze Amazon Linux 2 / unikamy r?cznego wpisywania AMI ID
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

//public IP dostanie z subnetu
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

resource "aws_lb_target_group" "tg" {
  name = var.tg_name
  port = var.http_port
  protocol = var.alb_protocol
  vpc_id = aws_vpc.main.id

  health_check {
    path = var.health_check_path
    port = var.http_port_string
  }

  tags = {
    Name = var.tg
  }
}

resource "aws_lb_target_group_attachment" "az1" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.ec2_az1.id
  port             = var.http_port
}

resource "aws_lb_target_group_attachment" "az2" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.ec2_z2.id
    port             = var.http_port
}

resource "aws_lb" "alb" {
  name = var.alb_name
  load_balancer_type = var.alb_type
  //internal znaczy czy ALB bedzie mial publiczny IP czy nie
  internal = var.alb_internal

  subnets = [
  aws_subnet.public_az1.id,
  aws_subnet.public_az2.id]

  security_groups = [aws_security_group.alb_sg.id]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port = var.http_port
    protocol = var.alb_protocol

  // definiujemy co ma sie stac z ruchem przychodzacym na listenera
    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.tg.arn
    }

}