provider "aws" {
  region     = "${var.aws_region}"
  access_key = "AKIAZRCHFY6Q24FSUH4G"
  secret_key = "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"
}

resource "aws_key_pair" "tf_demo" {
  key_name = "tf_demo"

  #/*  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCkU6sendj4pexOpGGQ+iUO9XfZSYDOhxdnMOu0SKoLnaRzZujFiWwMrqCRc9zZ5hY1wNcHbB5/dXXHWVGtmM1PV8gt7KpCD0Xq/5AJhkOZlziyxxsiKhTCjV2foBi2OXIBuOuHIuYNF1fFZelT39wd9mExBVm0tVtPFag9lr+VB5OiGnlaj5Ai0kDBjraFiuXxi4NsDP+u4PlNn4OH1ZAep4KwKNco5yjtlqZQPkLa2yxodInn0E6NPdtYVpBH+KMM2VkcoU+e8SgGZNbCN5DqU69CoZbPrOaw3jsrlM8nTJhupuJHs916n46SgGuwLAsrME3L+naVYrCMBbmh5GBz ec2-user@ip-172-31-84-136.ec2.internal"*/
  public_key = "${file("tf-demo.pub")}"
}

resource "aws_instance" "myfirstec2" {
  count                  = "${var.instance_count}"
  ami                    = "${lookup(var.ami,var.aws_region)}"
  instance_type          = "${var.instance_type}"
  vpc_security_group_ids = ["${aws_security_group.SG.id}"]
  key_name               = "${aws_key_pair.tf_demo.key_name}"
  user_data              = "${file("neeru")}"

  tags {
    #Name = "neeru-${count.index + 1}"
    Name = "${element(var.instance_tags, count.index)}"
  }
}

resource "aws_security_group" "SG" {
  name = "terraformSG"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "public_dns" {
  value = "${aws_instance.myfirstec2.*.public_dns}"
}

output "public_ip" {
  value = "${aws_instance.myfirstec2.*.public_ip}"
}

output "security_groups" {
  value = "${aws_instance.myfirstec2.*.security_groups}"
}
