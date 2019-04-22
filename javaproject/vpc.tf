# VPC for JAVA Application

resource "aws_vpc" "java_vpc" {
  cidr_block = "${var.vpc_cidr}"

  tags = {
    Name = "javavpc"
  }
}

# create Internet Gateway and attach to VPC

resource "aws_internet_gateway" "java_igw" {
  vpc_id = "${aws_vpc.java_vpc.id}"

  tags = {
    Name = "javaIGW"
  }
}

# Build subnets for our VPCs

resource "aws_subnet" "public" {
  count             = "${length(var.subnets_cidr)}"
  vpc_id            = "${aws_vpc.java_vpc.id}"
  availability_zone = "${element(var.azs,count.index)}"
  map_public_ip_on_launch = "true"
  cidr_block        = "${element(var.subnets_cidr, count.index)}"

  tags = {
    Name = "subnet-${count.index + 1}"
  }
}

# create Route table, Attach Internet Gateway and associate with public subnets

resource "aws_route_table" "public_rt" {
  vpc_id = "${aws_vpc.java_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.java_igw.id}"
  }

  tags = {
    Name = "PublicRT"
  }
}

# Attach routr table  with public subnets

resource "aws_route_table_association" "public" {
  count          = "${length(var.subnets_cidr)}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public_rt.id}"
}
