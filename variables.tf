variable "name" {}
variable "region" {}
variable "tags" {}

# Bastion SG
variable "bastion_egress_rules" {}
variable "bastion_ingress_cidr_blocks" {}
variable "bastion_ingress_rules" {}

# ALB SG
variable "alb_egress_rules" {}
variable "alb_ingress_cidr_blocks" {}
variable "alb_ingress_rules" {}

# DB SG
variable "db_egress_rules" {}
variable "db_ingress_cidr_blocks" {}
variable "db_ingress_rules" {}