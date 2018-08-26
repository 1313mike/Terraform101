variable "ami" {}
variable "subnet_id" {}

variable "instance_type" {
  default = "t2.micro"
}

variable "vpc_security_group_id" {
  type = "string"
}

variable "num_webs" {
  default = "2"
}

variable "identity" {}

resource "aws_instance" "web" {
  count                  = "${var.num_webs}"
  ami                    = "${var.ami}"
  instance_type          = "${var.instance_type}"
  subnet_id              = "${var.subnet_id}"
  vpc_security_group_ids = ["${var.vpc_security_group_id}"]
  key_name               = "${aws_key_pair.training.id}"

  tags {
    "Identity" = "${var.identity}"
    "Name"     = "web ${count.index+1}/${var.num_webs}"
    "Zip"      = "zap"
  }

  connection {
    user        = "ubuntu"
    private_key = "${file("~/.ssh/id_rsa")}"
  }

  provisioner "file" {
    source      = "assets"
    destination = "/tmp/"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo sh /tmp/assets/setup-web.sh",
    ]
  }
}

resource "aws_key_pair" "training" {
  key_name   = "${var.identity}-key"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}

output "public_ip" {
  value = "${aws_instance.web.*.public_ip}"
}

output "public_dns" {
  value = "${aws_instance.web.*.public_dns}"
}
