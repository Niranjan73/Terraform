# Create a new load balancer
resource "aws_elb" "java-elb" {
  name               = "java-elb"
 # availability_zones = ["${var.azs}"]
  subnets = ["${aws_subnet.public.*.id}"]
  security_groups = ["${aws_security_group.webservers.id}"]

/*  access_logs {
    bucket        = "foo"
    bucket_prefix = "bar"
    interval      = 60
  }*/

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

/*  listener {
    instance_port      = 8000
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = "arn:aws:iam::123456789012:server-certificate/certName"
  }*/

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/index.html"
    interval            = 30
  }

  instances                   = ["${aws_instance.webservers.*.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 100
  connection_draining         = true
  connection_draining_timeout = 300

  tags = {
    Name = "JAVA-terraform-elb"
  }
}

output "elb-dns-name" {
  value = "${aws_elb.java-elb.dns_name}"
		}
