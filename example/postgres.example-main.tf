
/*
 | --
 | -- If you are using an IAM role as the AWS access mechanism then
 | -- pass it as in_role_arn commonly through an environment variable
 | -- named TF_VAR_in_role_arn in addition to the usual AWS access
 | -- key, secret key and default region parameters.
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

module fresh_db {

    source = "./.."

    in_publicly_accessible = var.in_publicly_accessible
    in_db_subnet_ids       = var.in_publicly_accessible ? module.vpc-network.out_public_subnet_ids : module.vpc-network.out_private_subnet_ids
    in_security_group_id   = module.security-group.out_security_group_id
    in_database_name       = local.fresh_db_name

    in_ecosystem   = local.ecosystem_name
    in_timestamp   = local.timestamp
    in_description = local.description
}


module clone_db {

    source = "./.."

    in_publicly_accessible = var.in_publicly_accessible
    in_db_subnet_ids       = var.in_publicly_accessible ? module.vpc-network.out_public_subnet_ids : module.vpc-network.out_private_subnet_ids
    in_id_of_db_to_clone   = var.in_id_of_db_to_clone
    in_security_group_id   = module.security-group.out_security_group_id
    in_clone_snapshot      = true

    in_database_name = local.clone_db_name

    in_ecosystem   = local.ecosystem_name
    in_timestamp   = local.timestamp
    in_description = local.description
}


module vpc-network {

    source  = "devops4me/vpc-network/aws"
    version = "~> 1.0.2"

    in_vpc_cidr            = "10.81.0.0/16"
    in_num_public_subnets  = 2
    in_num_private_subnets = var.in_publicly_accessible ? 0 : 2

    in_ecosystem   = local.ecosystem_name
    in_timestamp   = local.timestamp
    in_description = local.description
}


module security-group {

    source     = "github.com/devops4me/terraform-aws-security-group"
    in_ingress = [ "postgres", "ssh" ]
    in_vpc_id  = module.vpc-network.out_vpc_id

    in_ecosystem   = local.ecosystem_name
    in_timestamp   = local.timestamp
    in_description = local.description
}


locals {

    fresh_db_name  = "brandnewdb"
    clone_db_name  = "snapshotdb"

    ecosystem_name = "sanjievesdb"
    timestamp = formatdate( "YYMMDDhhmmss", timestamp() )
    date_time = formatdate( "EEEE DD-MMM-YY hh:mm:ss ZZZ", timestamp() )
    description = "was created by me on ${ local.date_time }."
}
