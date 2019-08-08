
/*
 | -- #### ######################## ####
 | -- #### AWS Cloud Authentication ####
 | -- #### ######################## ####
 | --
 | -- This role arn prompts terraform to assume the role specified. Now
 | -- credentials will be sought from the environment when running within
 | -- local surrounds like (on a laptop), however when on an EC2 server
 | -- or within an ECS cluster the environment already has the role.
 | --
*/
variable in_role_arn {
    description = "The Role ARN to use when we assume role to implement the provisioning."
}

provider aws {
    assume_role {
        role_arn = var.in_role_arn
    }
}

locals {
    ecosystem_name = "integration"
    fresh_db_name  = "brandnewbox"
    clone_db_name  = "copycatbox"
}


variable in_id_of_db_to_clone {
    description = "The ID of mummy database to clone from."
}

output out_fresh_database_hostname { value = module.fresh_db.out_fresh_db_hostname }
output out_fresh_database_endpoint { value = module.fresh_db.out_fresh_db_endpoint }

output out_clone_database_hostname { value = module.clone_db.out_clone_db_hostname }
output out_clone_database_endpoint { value = module.clone_db.out_clone_db_endpoint }

output out_fresh_database_username { value = module.fresh_db.out_database_username }
output out_fresh_database_password { value = module.fresh_db.out_database_password }

output out_clone_database_username { value = module.clone_db.out_database_username }
output out_clone_database_password { value = module.clone_db.out_database_password }


module fresh_db {

    source = "./.."

    in_security_group_id = module.security-group.out_security_group_id
    in_db_subnet_ids     = module.vpc-network.out_private_subnet_ids
    in_database_name     = local.fresh_db_name

    in_ecosystem_name  = local.ecosystem_name
    in_tag_timestamp   = module.resource-tags.out_tag_timestamp
    in_tag_description = module.resource-tags.out_tag_description
}


module clone_db {

    source = "./.."

    in_security_group_id = module.security-group.out_security_group_id
    in_db_subnet_ids     = module.vpc-network.out_private_subnet_ids
    in_id_of_db_to_clone = var.in_id_of_db_to_clone
    in_clone_snapshot = true

    in_database_name = local.clone_db_name

    in_ecosystem_name  = local.ecosystem_name
    in_tag_timestamp   = module.resource-tags.out_tag_timestamp
    in_tag_description = module.resource-tags.out_tag_description
}


module vpc-network {

    source                 = "github.com/devops4me/terraform-aws-vpc-network"
    in_vpc_cidr            = "10.79.0.0/16"
    in_num_public_subnets  = 3
    in_num_private_subnets = 3

    in_ecosystem_name  = local.ecosystem_name
    in_tag_timestamp   = module.resource-tags.out_tag_timestamp
    in_tag_description = module.resource-tags.out_tag_description
}


module security-group {

    source         = "github.com/devops4me/terraform-aws-security-group"
    in_ingress     = [ "postgres" ]
    in_vpc_id      = module.vpc-network.out_vpc_id

    in_ecosystem_name  = local.ecosystem_name
    in_tag_timestamp   = module.resource-tags.out_tag_timestamp
    in_tag_description = module.resource-tags.out_tag_description
}


module resource-tags {

    source = "github.com/devops4me/terraform-aws-resource-tags"

}
