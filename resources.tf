### Set a Provider ###
provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

### Get Data from Existing Resources ###
# Get Amazon Machine Image
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/*ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  owners = ["099720109477"] # Canonical
}

### Create the Server Key ###
resource "aws_key_pair" "webserver_key" {
  key_name   = "serverkey"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDE0GfW5JoRswTLnob+3Hvptwj4H8Ns8UH5Knmg6l+1Obm5QY05RAbOwpPDI8KxwY2OOdI9SA6UdONCLGYG8HI/Avkk2Ig3bvqQpM1/VtI0qQdSdH/2bzH6UXL94gJWYtjDIDfgwVDiDtddnBxIdyHWrNe9NU/yCffgVKs/4BzLBElkYEZYtk7gXRGemOpCXanQlPQ3Tmcc9fVUeqeYS7Y6i5a8YsTRJbUeH6Jx3kby3IFo5ZekUxtS6VWOUfThAd8yhF5U0F28DE7gqk8v9qo8o0KpvhD2BJ3mwfU//T+9XzE9LDULU01ySLirOcQtOn0/lkk9+4Ha40G2Mvip9xoprhBpn5r71nVbpcaTZxLJYNSZjoqxEs3dWvllTeh0Nnc4xWLtL1NzOr7F42dNK1fPiZuTzLcdmN+kEMWpHoyP82ESNGSSlAkCw3y7kjXZeKs9PJ4jSaN0EHsBum76ttFf4GhaHW1pnB7iotDH0637OlLh1YU4oHkPmnRXZSYbdx54I8ZZfAS8Vj2iEpOPmHyiV4uWQCLwQzv5sN2dGAnritipmJKP8rvfxfk0OHU1ppprj6dXR50wjE/pfiE8+iEahyIvZqoBTRRg6gZEXO6gtySssJ3JPkxY8weO5zWniZ8zuiE9nNbc46Av/VF+ms2uT+trXpHl4jCzrkDxqD6BVw== webserver key"
}

### Create Web Server Security Group ###
resource "aws_security_group" "webserver_sg" {
  name        = "${var.project}-wssg"

  ingress {
    from_port       = "${var.http_port}"
    to_port         = "${var.http_port}"
    protocol        = "tcp"
    cidr_blocks = ["${var.any_ip}"]
  }

  ingress {
    from_port       = "${var.ssh_port}"
    to_port         = "${var.ssh_port}"
    protocol        = "tcp"
    cidr_blocks = ["${var.any_ip}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.any_ip}"]
  }

  tags {
    Name        = "${var.project}-wssg"
    Project     = "${var.project}"
  }
}

### Create the Web Server ###
resource "aws_instance" "webserver" {
  ami                    = "${data.aws_ami.ubuntu.id}"
  instance_type          = "${var.instance_type}"
  key_name               = "${aws_key_pair.webserver_key.key_name}"
  user_data              = "${file("${path.module}/user-data.sh")}"
  security_groups        = ["${aws_security_group.webserver_sg.name}"]

  tags {
    Name        = "${var.project}-ws"
    Project     = "${var.project}"
  }
}