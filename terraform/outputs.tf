output "alb_cname" {
  value = "${aws_alb.main.dns_name}"
}

output "app-repo" {
  value = "${aws_ecr_repository.app.repository_url}"
}
