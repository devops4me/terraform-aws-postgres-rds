

locals {

    db_username = "user_rw_${ random_string.username_suffix.result }"

}


/*
 | --
 | -- Create a simple AWS PostgreSQL RDS database from either the
 | -- last available snapshot, or via the specified snapshot identifier
 | -- of another database.
 | --
 | -- This module effectively clones a database at the point at which
 | -- the snapshot in question is taken.
 | --
*/
resource aws_db_instance postgres {

########    snapshot_identifier = length( data.aws_db_snapshot.parent ) == 0 ? null : data.aws_db_snapshot.parent[0]. ##### is this ID
    identifier = "${ var.in_database_name }-${ var.in_ecosystem_name }-${ var.in_tag_timestamp }"

    name     = var.in_database_name
    username = local.db_username
    password = random_string.dbpassword.result
    port     = 5432

    engine         = "postgres"
    instance_class = "db.t2.large"
    multi_az       = true
    allocated_storage = 32

    storage_encrypted      = false
    vpc_security_group_ids = [ var.in_security_group_id ]
    db_subnet_group_name   = aws_db_subnet_group.me.id
    skip_final_snapshot    = true

}


#### data aws_db_snapshot parent {
####     count = length( var.in_id_of_db_to_clone ) > 0 ? 1 : 0
####     most_recent = true
####     db_instance_identifier = var.in_id_of_db_to_clone
#### }


/*
 | --
 | -- This multi-availability zone postgres database will be created within
 | -- the (usually) private subnets denoted by in_db_subnet_ids variable.
 | --
*/
resource aws_db_subnet_group me {

    name_prefix = "db-${ var.in_ecosystem_name }"
    description = "RDS postgres subnet group for the ${ var.in_ecosystem_name } database."
    subnet_ids  = var.in_db_subnet_ids

    tags = {
        Name   = "db-subnet-group-${ var.in_ecosystem_name }-${ var.in_tag_timestamp }"
        Class = "${ var.in_ecosystem_name }"
        Desc   = "This RDS postgres database subnet group for ${ var.in_ecosystem_name } ${ var.in_tag_description }"
    }
}


/*
 | --
 | -- The Terraform generated database password will contain
 | -- thirty two alphanumeric characters and no specials.
 | --
*/
resource random_string dbpassword {
    length  = 32
    upper   = true
    lower   = true
    number  = true
    special = false
}


/*
 | --
 | -- It is good practise for the database user name to be suffixed
 | -- with at least a few random lowercase alpha characters.
 | --
*/
resource random_string username_suffix {
    length  = 7
    upper   = false
    lower   = true
    number  = true
    special = false
}
