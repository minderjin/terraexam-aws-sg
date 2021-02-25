provider "aws" {
  # profile = "default"
  region = var.region
}

module "web_sg" {
   source = "terraform-aws-modules/security-group/aws//modules/http-80"
#   source = "terraform-aws-modules/terraform-aws-security-group/modules/http-80"

  name        = "web-server"
  description = "${var.name}'s Security group for web-server with HTTP ports open within VPC"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress_cidr_blocks = ["0.0.0.0/0"]

  tags = var.tags

}
