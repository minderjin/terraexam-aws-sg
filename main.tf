provider "aws" {
  # profile = "default"
  region = var.region
}

data "aws_security_group" "default" {
  name = "default"
  #   vpc_id = module.vpc.vpc_id
  #   vpc_id = "vpc-04bc8955784f0fa6d"
  vpc_id = local.vpc_id
}

local "vpc_id" {
  value = "vpc-04bc8955784f0fa6d"
}

module "web_sg" {
  source = "terraform-aws-modules/security-group/aws//modules/http-80"
  #   source = "terraform-aws-modules/terraform-aws-security-group/modules/http-80"

  name        = "web-server"
  description = "${var.name} Security group for web-server"

  #   vpc_id      = "${module.vpc.vpc_id}"
  vpc_id = "vpc-04bc8955784f0fa6d"

  ingress_cidr_blocks = ["0.0.0.0/0"]

  tags = var.tags

}

module "custom_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "custom"
  description = "${var.name} Security group for custom ports"
  vpc_id      = "vpc-04bc8955784f0fa6d"

  # https
  ingress_cidr_blocks = ["10.0.0.0/16"]
  ingress_rules       = ["https-443-tcp"]

  # custom port & postgresql
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

module "db_computed_source_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "db_computed_source_sg"
  description = "${var.name} Security group for db_computed_source_sg"

  vpc_id = "vpc-04bc8955784f0fa6d" # these are valid values also - "${module.vpc.vpc_id}" and "${local.vpc_id}"

  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "mysql-tcp"
      source_security_group_id = "${module.web_sg.this_security_group_id}"
    }
  ]
  number_of_computed_ingress_with_source_security_group_id = 1
}

module "db_computed_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "db_computed_sg"
  description = "${var.name} Security group for db_computed_sg"

  vpc_id = "vpc-04bc8955784f0fa6d" # these are valid values also - "${module.vpc.vpc_id}" and "${local.vpc_id}"


  ingress_cidr_blocks = ["10.0.0.0/16", "${data.aws_security_group.default.id}"]

  computed_ingress_cidr_blocks           = ["${module.vpc.vpc_cidr_block}"]
  number_of_computed_ingress_cidr_blocks = 1
}

# module "db_computed_merged_sg" {
#   # omitted for brevity

#   computed_ingress_cidr_blocks = ["10.10.0.0/16", "${module.vpc.vpc_cidr_block}"]
#   number_of_computed_ingress_cidr_blocks = 2
# }