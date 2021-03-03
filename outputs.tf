# this_security_group_description
#     Description: The description of the security group

# this_security_group_id
#     Description: The ID of the security group

# this_security_group_name
#     Description: The name of the security group

# this_security_group_owner_id
#     Description: The owner ID

# this_security_group_vpc_id
#     Description: The VPC ID


output "bastion_security_group_id" {
  value = module.bastion_sg.this_security_group_id
}

output "alb_security_group_id" {
  value = module.alb_sg.this_security_group_id
}

output "was_security_group_id" {
  value = module.was_sg.this_security_group_id
}

output "db_security_group_id" {
  value = module.db_sg.this_security_group_id
}
