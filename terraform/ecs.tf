data "aws_ecs_task_definition" "app" {
  task_definition = "${aws_ecs_task_definition.app.family}"
}

resource "aws_ecs_cluster" "app" {
  name = "app-cluster"
}

resource "aws_ecs_task_definition" "app" {
  family = "app-service"
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn = "${aws_iam_role.ecs_tasks.arn}"
  # not sure if task_role_arn actually needs to be set to this too
  task_role_arn = "${aws_iam_role.ecs_tasks.arn}"
  cpu = 256
  memory = 512
  container_definitions = <<DEFINITION
[
  {
    "name": "app-service",
    "cpu": 256,
    "memory": 512,
    "image": "${aws_ecr_repository.app.repository_url}",
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": ${var.app_port},
        "hostPort": ${var.app_port}
      }
    ]
  }
]
DEFINITION
}

resource "aws_ecs_service" "app" {
  name = "app-service"
  cluster = "${aws_ecs_cluster.app.id}"
  launch_type = "FARGATE"
  depends_on = ["aws_alb_listener.app", "aws_iam_policy_attachment.ecs_tasks"]
  network_configuration {
    security_groups = ["${aws_security_group.ecs.id}"]
    subnets         = ["${aws_subnet.public.*.id}"]
    assign_public_ip = true
  }
  load_balancer {
    target_group_arn = "${aws_alb_target_group.app.arn}"
    container_name   = "app-service"
    container_port   = "${var.app_port}"
  }
  desired_count = 1
  # does the revision get wonky if terraform is applied after a circleci build?
  task_definition = "${aws_ecs_task_definition.app.family}:${max("${aws_ecs_task_definition.app.revision}", "${data.aws_ecs_task_definition.app.revision}")}"
  lifecycle {
    ignore_changes = ["desired_count"]
  }
}
