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

# module "custom_sg" {
    
# }