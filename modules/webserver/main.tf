resource "aws_default_security_group" "nginx-default-sg" {
    vpc_id = var.vpc_id
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [var.myip]
        }
    
    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        }
  
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        prefix_list_ids = []
        }
    tags = {
      "Name" = "${var.env_prefix}-default-sg"
      } 
}

data "aws_ami" "latest_ubuntu" {
    most_recent = true
    owners = ["099720109477"] # Canonical
    filter {
        name = "name"
        values = [var.ami_name]
    }
}

resource "aws_key_pair" "prince-nginx" {
    key_name = "prince-nginx"
    public_key = file(var.public_key_path)
  
}

resource "aws_instance" "nginx-server" {
    ami = data.aws_ami.latest_ubuntu.id
    instance_type = var.instance_type

    vpc_security_group_ids = [aws_default_security_group.nginx-default-sg.id]
    subnet_id = var.subnet_id
    availability_zone = var.avail_zone

    associate_public_ip_address = true
    key_name = aws_key_pair.prince-nginx.key_name

    user_data = file("docker-nginx.sh")
    tags = {
      "Name" = "${var.env_prefix}-server"
      }
}