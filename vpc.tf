locals  {
  vpc_name = "${var.environment}-${var.vpc_name}"
  internet_gateway = "${var.environment}-${var.internet_gateway}"
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
  }

}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = merge(local.common_tags, {
    Name = var.vpc_name
  })
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.common_tags, {
    Name = local.internet_gateway
  })
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
  // potrzebne do automatycznego przypisywania publicznych IP do instancji w tym subnecie. Bez tego EC2 nie dostanie publicznego IP
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
