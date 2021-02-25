provider "aws" {
  # profile = "default"
  region = var.region
}

module "web_sg" {
   source = "terraform-aws-modules/security-group/aws//modules/http-80"
#   source = "terraform-aws-modules/terraform-aws-security-group/modules/http-80"

  name        = "web-server"
  description = "${var.name} Security group for web-server"
  
#   vpc_id      = "${module.vpc.vpc_id}"
  vpc_id      = "vpc-04bc8955784f0fa6d"

  ingress_cidr_blocks = ["0.0.0.0/0"]

  tags = var.tags

}

module "custom_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "custom"
  description = "${var.name} Security group for custom ports"
  vpc_id      = "vpc-04bc8955784f0fa6d"

  ingress_cidr_blocks      = ["10.0.0.0/16"]
  ingress_rules            = ["https-443-tcp"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 8080
      to_port     = 8090
      protocol    = "tcp"
      description = "Custom ports"
      cidr_blocks = "10.0.0.0/16"
    },
    {
      rule        = "postgresql-tcp"
      cidr_blocks = "0.0.0.0/0"
    },
  ] 
}