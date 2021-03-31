###############################################################################################################################################################################
# Terraform loads variables in the following order, with later sources taking precedence over earlier ones:
# 
# Environment variables
# The terraform.tfvars file, if present.
# The terraform.tfvars.json file, if present.
# Any *.auto.tfvars or *.auto.tfvars.json files, processed in lexical order of their filenames.
# Any -var and -var-file options on the command line, in the order they are provided. (This includes variables set by a Terraform Cloud workspace.)
###############################################################################################################################################################################
#
# terraform cloud 와 별도로 동작
# terraform cloud 의 variables 와 동등 레벨
#
# Usage :
#
#   terraform apply -var-file=terraform.tfvars
#
#
# [Terraform Cloud] Environment Variables
#
#     AWS_ACCESS_KEY_ID
#     AWS_SECRET_ACCESS_KEY 
#

name = "example"

region = "us-west-2"

tags = {
  Terraform   = "true"
  Environment = "dev"
}


## Bastion SG
bastion_egress_rules        = ["all-all"]
bastion_ingress_cidr_blocks = ["211.60.50.190/32"]
bastion_ingress_rules       = ["ssh-tcp"]

## ALB SG
alb_egress_rules        = ["all-all"]
alb_ingress_cidr_blocks = ["0.0.0.0/0"]
alb_ingress_rules       = ["http-80-tcp", "https-443-tcp"]

## DB SG
db_egress_rules        = ["all-all"]
db_ingress_cidr_blocks = []             # []일 경우, vpc_cidr_block 세팅됨
db_ingress_rules       = ["mysql-tcp"]
