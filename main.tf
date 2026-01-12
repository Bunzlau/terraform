
//tworzymy VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = var.vpc_name
  }
}

//tworzymy Internet Gateway z przypisaniem do VPC
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = var.internet_gateway
  }
}
//tworzymy Egress Only Internet Gateway z przypisaniem do VPC
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = var.public_route_table
  }
}

//tworzymy publiczne subnets w dwoch AZ
resource "aws_subnet" "public_az1" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.public_subnet_az1_cidr
  availability_zone = var.public_subnet_az1_az
  // potrzebne do automatycznego przypisywania publicznych IP do instancji w tym subnecie
  map_public_ip_on_launch = true

    tags = {
    Name = var.public_subnet_az1_name
  }
}

//tworzymy publiczne subnets w dwoch AZ
resource "aws_subnet" "public_az2" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.public_subnet_az2_cidr
  availability_zone = var.public_subnet_az2_az
  map_public_ip_on_launch = true

  tags = {
    Name = var.public_subnet_az2_name
  }
}

//bez tego subnet nie ma internetu, laczymy route table z subnetami
resource "aws_route_table_association" "az1" {
  route_table_id = aws_route_table.public.id
    subnet_id      = aws_subnet.public_az1.id
}

resource "aws_route_table_association" "az2" {
  route_table_id = aws_route_table.public.id
    subnet_id      = aws_subnet.public_az2.id
}

//tworzymy security group dla ALB z regu?a na HTTP (80) inbound
resource "aws_security_group" "alb_sg" {
  name        =  var.alb_security_group
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP from anywhere"
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
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
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
}

//pobieramy najnowszy Amazon Linux 2 AMI w regionie
//znajdzie najnowsze Amazon Linux 2 / unikamy r?cznego wpisywania AMI ID
data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"] // Amazon
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

//tworzymy TARGET GROUP dla ALB. PO HTTP GET
resource "aws_lb_target_group" "tg" {
  name = var.tg_name
  port = var.http_port
  protocol = "HTTP"
  vpc_id = aws_vpc.main.id

  health_check {
    path = "/"
    port = var.http_port_string
  }

  tags = {
    Name = var.tg
  }
}

//Podpięcie EC2 do TARGET GROUPS
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

//tworzymy Application Load Balancer
resource "aws_lb" "alb" {
  name = var.alb_name
  load_balancer_type = "application"
  //internal znaczy czy ALB bedzie mial publiczny IP czy nie
  internal = false

  subnets = [
  aws_subnet.public_az1.id,
  aws_subnet.public_az2.id]

  security_groups = [aws_security_group.alb_sg.id]
}

//listener dla ALB, żeby przekierowywał ruch do target group
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port = var.http_port
    protocol = "HTTP"

  // definiujemy co ma sie stac z ruchem przychodzacym na listenera
    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.tg.arn
    }

}