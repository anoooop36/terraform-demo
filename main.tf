provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region
}

resource "aws_vpc" "vpcByTFE" {
  cidr_block  = "10.0.0.0/16"
}

resource "aws_subnet" "subnetByTFE" {
  vpc_id     =  "${aws_vpc.vpcByTFE.id}"
  cidr_block = "10.0.32.0/24"
}

resource "aws_network_interface" "nicByTFE" {
  subnet_id = aws_subnet.subnetByTFE.id
}

resource "aws_instance" "ec2Instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  tags          = var.instance_tag

  network_interface {
    network_interface_id = aws_network_interface.nicByTFE.id
    device_index         = 0
  }
}

variable "access_key" {}

variable "secret_key" {}

variable "region" {}


variable "ami_id" {
  default = "ami-0022f774911c1d690"
  type    = string
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "instance_tag" {
  default = {
    name = "First Ec2 Instance"
    env  = "Dev",
  }
  type = object({
    name = string
    env  = string
  })
}

