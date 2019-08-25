
/*
 | --
 | -- The database username is constructed with a prefix of "user_rw_"
 | -- and a random 7 character suffix as per best practise.
 | --
 | -- This reduces the attack surface and minimizes accidental connections
 | -- to a (say) canary (as opposed to a production database).
 | --
*/
locals {
    db_username = "user_rw_${ random_string.username_suffix.result }"
}


/*
 | --
 | -- If the in_clone_snapshot flag is set to false we take this as a
 | -- signal to create a new blank database.
 | --
 | -- Any snapshot identifier that may be provided is ignored so it is
 | -- safe to set this variable even when you want a new database.
 | --
*/
resource aws_db_instance fresh {

    count = var.in_clone_snapshot ? 0 : 1
    identifier = "${ var.in_database_name }-fresh-${ var.in_ecosystem_name }-${ var.in_tag_timestamp }"

    name     = var.in_database_name
    username = local.db_username
    password = random_string.dbpassword.result
    port     = 5432

    engine         = "postgres"
    instance_class = "db.t2.large"
    multi_az       = true
    allocated_storage = 32

    vpc_security_group_ids = [ var.in_security_group_id ]
    db_subnet_group_name   = aws_db_subnet_group.me.id
    skip_final_snapshot    = true

    copy_tags_to_snapshot   = true
    storage_encrypted       = true
    backup_retention_period = 28
    backup_window           = "21:00-23:00"
    maintenance_window      = "mon:00:00-mon:03:00"

    tags = merge( local.database_tags, local.fresh_database_tags, var.in_mandatory_tags )

}


/*
 | --
 | -- If the in_clone_snapshot flag is true we expect a variable to be
 | -- set named in_id_of_db_to_clone. A search is enacted to find the
 | -- latest snapshot of the specified database and the database created
 | -- here is a clone based on that snapshot.
 | --
 | -- Just providing the ID will not cause this cloning to happen, the
 | -- boolean variable in_clone_snapshot must also be set to true.
 | --
 | -- Note that the username and password are absent. You are allowed to
 | -- reset the database name, however you must know the username and
 | -- password of the DB the snapshot was created from.
 | --
*/
resource aws_db_instance clone {

    count = var.in_clone_snapshot ? 1 : 0

    snapshot_identifier = data.aws_db_snapshot.from[0].id
    identifier = "${ var.in_database_name }-clone-${ var.in_ecosystem_name }-${ var.in_tag_timestamp }"

    name     = var.in_database_name
    port     = 5432

    engine         = "postgres"
    instance_class = "db.t2.large"
    multi_az       = true

    vpc_security_group_ids = [ var.in_security_group_id ]
    db_subnet_group_name   = aws_db_subnet_group.me.id
    skip_final_snapshot    = true

    copy_tags_to_snapshot   = true
    storage_encrypted       = true
    backup_retention_period = 28
    backup_window           = "21:00-23:00"
    maintenance_window      = "mon:00:00-mon:03:00"

    tags = merge( local.database_tags, local.cloned_database_tags, var.in_mandatory_tags )
}


/*
 | --
 | -- This data source takes the database ID and returns the Id of the
 | -- last known snapshot. Beware - a search will be enacted if the ID
 | -- is provided even when the clone snapshot flag is false.
 | --
*/
data aws_db_snapshot from {

    count = length( var.in_id_of_db_to_clone ) > 0 ? 1 : 0
    most_recent = true
    db_instance_identifier = var.in_id_of_db_to_clone

}


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
    tags        = merge( local.subnet_group_tags, var.in_mandatory_tags )
}


/*
 | --
 | -- The Terraform generated database password will contain
 | -- forty-eight characters that may include all alpha-numerics
 | -- and eight special printable characters.
 | --
*/
resource random_string dbpassword {
    length  = 48
    upper   = true
    lower   = true
    number  = true
    special = true
    override_special = "()[]-_:="
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



/*
 | --
 | -- These tag definitions are attached onto the databases that are
 | -- cloned or createed and also the database subnet group.
 | --
*/
locals {

    subnet_group_tags = {
        Name   = "db-subnet-group-${ var.in_ecosystem_name }-${ var.in_tag_timestamp }"
        Desc   = "This RDS postgres database subnet group for ${ var.in_ecosystem_name } ${ var.in_tag_description }"
    }

    database_tags = {
        Name  = var.in_database_name
        Id    = "${ var.in_database_name }-${ var.in_ecosystem_name }-${ var.in_tag_timestamp }"
    }

    cloned_database_tags = {
        Desc   = "This PostgreSQL database named ${ var.in_database_name } was cloned from snapshot ${ data.aws_db_snapshot.from[0].id } and ${ var.in_tag_description }"
    }

    fresh_database_tags = {
        Desc  = "This brand new PostgreSQL database named ${ var.in_database_name } ${ var.in_tag_description }"
    }

}
