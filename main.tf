terraform {
    required_version = ">= 0.12.0"
    backend "s3" {
      bucket = "nginx-terraform"
      key = "terraform.tfstate"
      region = "ap-south-1"
    }
}

resource "aws_vpc" "nginx_vpc" {
    cidr_block = var.vpc_cidr_block
    tags = {
      "Name" = "${var.env_prefix}-vpc"
    }
  
}

module "nginx_subnet" {
  source = "./modules/subnet"
  vpc_id = aws_vpc.nginx_vpc.id
  default_route_table_id = aws_vpc.nginx_vpc.default_route_table_id
  subnet_cidr_block = var.subnet_cidr_block
  avail_zone = var.avail_zone
  env_prefix = var.env_prefix
}

module "nginx_server" {
    source = "./modules/webserver"
    vpc_id = aws_vpc.nginx_vpc.id
    avail_zone = var.avail_zone
    env_prefix = var.env_prefix
    subnet_id = module.nginx_subnet.subnet.id
    instance_type = var.instance_type
    public_key_path = var.public_key_path
    myip = var.myip
    ami_name = var.ami_name
    
}







