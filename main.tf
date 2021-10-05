terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider to comminicate with the AWS API
provider "aws" {
  region     = "eu-central-1"
  access_key = "ACCESS_KEY"
  secret_key = "SECRET_KEY"
}

# Generting a Key-Pair in AWS Console under EC2 Instances to connect to the EC2 Instance that is created by Terraform
# Import the Key-Pair in PuTTy Key Generator and save the private Key as .ppk-File
# Connect to the Web Server from PuTTy with the User "ubuntu@IP" and private Key

# Create VPC: Virtual Private Network is a private Network that is isolate from VPCs
resource "aws_vpc" "terraform-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "production-network"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "terraform-gateway" {
  vpc_id = aws_vpc.terraform-vpc.id
  tags = {
    Name = "internet-gateway"
  }
}

# Create Custom Route Table
resource "aws_route_table" "terraform-route-table" {
  vpc_id = aws_vpc.terraform-vpc.id
  route = [
    {
      # Default Route for IPv4 so the Traffic from the Subnet can go out to the Internet
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.terraform-gateway.id
    },
    {
      # Default Route for IPv6 so the Traffic from the Subnet can go out to the Internet
      ipv6_cidr_block = "::/0"
      gateway_id      = aws_internet_gateway.terraform-gateway.id
    }
  ]
  tags = {
    Name = "route-table"
  }
}

#
variable "subnet-prefix" {
  description = "CIDR Block for the Subnet"
  #default =
  type = [string]
}


# Create a Subnet: Subnets belong to a VPC
resource "aws_subnet" "terraform-subnet-1" {
  vpc_id = aws_vpc.terraform-vpc.id
  # Define the Subnet which is used
  cidr_block = var.subnet-prefix[0].cidr_block
  # Ressources shoud be in the same Availability Zone
  availability_zone = "eu-central-1"
  tags = {
    Name = var.subnet-prefix[0].name
  }
}

# Create a Subnet: Subnets belong to a VPC
resource "aws_subnet" "terraform-subnet-2" {
  vpc_id = aws_vpc.terraform-vpc.id
  # Define the Subnet which is used
  cidr_block = var.subnet-prefix[1].cidr_block
  # Ressources shoud be in the same Availability Zone
  availability_zone = "eu-central-1"
  tags = {
    Name = var.subnet-prefix[1].name
  }
}

# Associate Subnet with Route Table
resource "aws_route_table_association" "terraform-route-table-association" {
  subnet_id      = aws_subnet.terraform-subnet-1.id
  route_table_id = aws_route_table.terraform-route-table.id
}

# Create Security Group to allow Port 22, 80, 443
resource "aws_security_group" "terraform-security-group-allow-web" {
  name        = "allow_web_traffic"
  description = "Allow Web Traffic"
  vpc_id      = aws_vpc.terraform-vpc.id
  ingress = [
    {
      description = "HTTP Traffic"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      # Define which Subnets can reach the Port - Default means everyone can access
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    },
    {
      description = "HTTPS Traffic"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      # Define which Subnets can reach the Port - Default means everyone can access
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    },
    {
      description = "SSH Traffic"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      # Define which Subnets can reach the Port - Default means everyone can access
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  ]

  egress = [
    {
      # Every Port is allowed
      from_port = 0
      to_port   = 0
      # Every Protocoll is allowed
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  ]
  tags = {
    Name = "security-group-allow-web"
  }
}

# Create a Network Interface with an IP in the Subnet
resource "aws_network_interface" "terraform-network-interface" {
  subnet_id = aws_subnet.terraform-subnet-1.id
  # Fix IP in VPC for the Network Interface
  private_ips     = [var.subnet-prefix]
  security_groups = [aws_security_group.terraform-security-group-allow-web]
}

# Assign an elastic IP to the Network Interface
resource "aws_eip" "terraform-elastic-ip" {
  vpc               = true
  network_interface = aws_network_interface.terraform-network-interface.id
  # Reference the Network Interface
  associate_with_private_ip = var.subnet-prefix
  depends_on                = [aws_internet_gateway.terraform-gateway]
}

# Output the Pulibc IP from the Web Server
output "terraform-public-ip" {
  value = aws_eip.terraform-elastic-ip.public_ip
}

# Create Ubuntu server and install / enable Apache2
# Create EC2 Istance
resource "aws_instance" "terraform-web-server" {
  # Ubuntu Server 20.04 LTS AMI
  ami           = "ami-05f7491af5eef733a"
  instance_type = "t2.micro"
  # Ressources shoud be in the same Availability Zone
  availability_zone = "eu-central-1"
  # Refer to Key-Pair which was created from the AWS Console
  key_name = "terraform-example-key"
  network_interface {
    # This si the first Network Interface which si associated with this Devuce
    device_index            = 0
    netnetwork_interface_id = aws_network_interface.terraform-network-interface.id
  }
  user_data = <<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt install apache2 -y
    sudo systemctl start apache2
    sudo bash -c "echo Your Web Server > /var/www/html/index.html"
    EOF
  tags = {
    name = "web-server"
  }
}
