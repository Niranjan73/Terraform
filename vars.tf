#terraform supports diff types of variables
# 1. string
# 2. List
# 3.Map

variable "ami" {
  type = "map"

  default = {
    us-east-1  = "ami-0de53d8956e8dcf80"
    us-west-1  = "ami-0ec1ad91f200c15a8"
    ap-south-1 = "ami-5b673c34"
  }
}

#variable "ami" {
#  default ="ami-011b3ccf1bd6db744" }

variable "instance_type" {
  default = "t2.micro"
}

variable "aws_region" {
  default = "ap-south-1"
}

variable "instance_count" {
  #default = 2 
}

variable "instance_tags" {
  type    = "list"
  default = ["sonar", "jenkins", "Nexus"]
}
