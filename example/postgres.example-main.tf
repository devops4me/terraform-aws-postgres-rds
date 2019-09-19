
### ############################ ###
### Example RDS Postgres Outputs ###
### ############################ ###

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

    in_ecosystem  = local.ecosystem_name
    in_timestamp   = local.timestamp
    in_description = local.description
}


module clone_db {

    source = "./.."

    in_security_group_id = module.security-group.out_security_group_id
    in_db_subnet_ids     = module.vpc-network.out_private_subnet_ids
    in_id_of_db_to_clone = var.in_id_of_db_to_clone
    in_clone_snapshot = true

    in_database_name = local.clone_db_name

    in_ecosystem  = local.ecosystem_name
    in_timestamp   = local.timestamp
    in_description = local.description
}


module vpc-network {

    source                 = "devops4me/vpc-network/aws"
    version                = "1.0.2"

    in_vpc_cidr            = "10.81.0.0/16"
    in_num_public_subnets  = 3
    in_num_private_subnets = 3

    in_ecosystem  = local.ecosystem_name
    in_timestamp   = local.timestamp
    in_description = local.description
}


module security-group {

    source         = "github.com/devops4me/terraform-aws-security-group"
    in_ingress     = [ "postgres" ]
    in_vpc_id      = module.vpc-network.out_vpc_id

    in_ecosystem_name  = local.ecosystem_name
    in_tag_timestamp   = local.timestamp
    in_tag_description = local.description
}


locals {
    fresh_db_name  = "brandnewdb"
    clone_db_name  = "snapshotdb"
}


variable in_id_of_db_to_clone {
    description = "The ID of mummy database to clone from."
}



/*
 | --
 | -- If you are using an IAM role as the AWS access mechanism then
 | -- pass it as in_role_arn commonly through an environment variable
 | -- named TF_VAR_in_role_arn in addition to the usual AWS access
 | -- key, secret key and default region parameters.
 | --
 | -- Individuals and small businesses without hundreds of AWS accounts
 | -- can omit the in_role_arn variable. and thanks to dynamic assignment
 | --
*/
provider aws {
    dynamic assume_role {
        for_each = length( var.in_role_arn ) > 0 ? [ var.in_role_arn ] : [] 
        content {
            role_arn = assume_role.value
	}
    }
}

variable in_role_arn {
    description = "The Role ARN to use when we assume role to implement the provisioning."
    default = ""
}


/*
 | --
 | -- ### ############# ###
 | -- ### Resource Tags ###
 | -- ### ############# ###
 | --
 | -- Terraform will tag every significant resource allowing you to report and collate
 | --
 | --   [1] - all infrastructure in all environments dedicated to your app (ecosystem_name)
 | --   [2] - the infrastructure dedicated to this environment instance (timestamp)
 | --
 | -- The human readable description reveals the when, where and what of the infrastructure.
 | --
*/
locals {
    ecosystem_name = "dbstack"
    timestamp = formatdate( "YYMMDDhhmmss", timestamp() )
    date_time = formatdate( "EEEE DD-MMM-YY hh:mm:ss ZZZ", timestamp() )
    description = "was created by me on ${ local.date_time }."
}
