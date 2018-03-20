provider "aws" {
  region = "eu-west-2"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_instance" "es-stack" {
  ami = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.es-stack-securitygroup.id}"]

  tags {
    Name = "ES Stack"
  }
}

resource "aws_security_group" "es-stack-securitygroup" {
  name = "es-stack-inbound"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

#resource "aws_eip" "es-stack-eip" {
#  instance = "${aws_instance.es-stack.id}"
#  vpc      = true
#}

output "public_ip" {
  description = "List of up public IPs for AWS Instances"
  value = "${aws_instance.es-stack.public_ip}"
}
