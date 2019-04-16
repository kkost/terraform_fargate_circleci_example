variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "prefix" {
  default = "app"
}

variable "aws_region" {
  default = "eu-west-1"
}

data "aws_availability_zones" "available" {}

variable "vpc_main" {
  default = "10.0.0.0/16"
}

variable "app_port" {
  default = "5000"
}
