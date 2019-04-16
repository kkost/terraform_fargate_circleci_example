resource "aws_security_group" "lb" {
  name = "lb"
  vpc_id = "${aws_vpc.main.id}"

  ingress {
    protocol = "tcp"
    from_port = 80
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ecs" {
  name = "ecs-lb"
  vpc_id = "${aws_vpc.main.id}"

  ingress {
    protocol = "tcp"
    from_port = "${var.app_port}"
    to_port = "${var.app_port}"
    security_groups = ["${aws_security_group.lb.id}"]
  }

  egress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
