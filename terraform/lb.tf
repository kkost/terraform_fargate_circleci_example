resource "aws_alb" "main" {
  name = "app-lb"
  subnets = ["${aws_subnet.public.*.id}"]
  security_groups = ["${aws_security_group.lb.id}"]
}

resource "aws_alb_target_group" "app" {
  name = "app"
  port = 80
  protocol = "HTTP"
  vpc_id = "${aws_vpc.main.id}"
  target_type = "ip"
}

resource "aws_alb_listener" "app" {
  load_balancer_arn = "${aws_alb.main.id}"
  port = "80"
  protocol = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.app.id}"
    type = "forward"
  }
}
