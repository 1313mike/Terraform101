#
# DO NOT DELETE THESE LINES UNTIL INSTRUCTED TO!
#
# Your AMI ID is:
#
#     ami-059e7901352ebaef8
#
# Your subnet ID is:
#
#     subnet-04eb48ca4b04c518a
#
# Your VPC security group ID is:
#
#     sg-05183e0c5832e5762
#
# Your Identity is:
#
#     082318-bison
#
variable "access_key" {}

variable "secret_key" {}

variable "region" {
  default = "us-west-1"
}

variable "ami" {}
variable "subnet_id" {}

variable "instance_type" {
  default = "t2.micro"
}

variable "vpc_security_group_id" {
type = "string"}
variable "identity" {}

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

module "server" {
  source = "./server"
  ami                    = "${var.ami}"
  instance_type          = "${var.instance_type}"
  subnet_id              = "${var.subnet_id}"
  vpc_security_group_id = "${var.vpc_security_group_id}"
  identity = "${var.identity}"

}

output "public_ip" {
  value = "${module.server.public_ip}"
}
