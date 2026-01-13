

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




