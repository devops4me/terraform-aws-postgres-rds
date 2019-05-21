
/*
 | --
 | -- Create a simple 32G AWS PostgreSQL RDS database. This module suits
 | -- rapid proof of concept development - it is not designed to provision
 | -- a production quality enterprise database.
 | --
 | -- The username is readwrite and the database listens on port 5432.
 | -- Just provide a security group, private subnet ids, the database name
 | -- and the ubiquitous tag information.
 | --
 | -- The only outputs needed are the out_database_hostname and the simple
 | -- terraform generated out_database_password.
 | --
*/
resource aws_db_instance postgres
{
    name                   = "${var.in_database_name}"
    vpc_security_group_ids = ["${ var.in_security_group_id }"]
    db_subnet_group_name   = "${ aws_db_subnet_group.object.id }"

    allocated_storage = "32"
    engine            = "postgres"
    instance_class    = "db.t2.micro"
    multi_az          = "true"
    username          = "readwrite"
    port              = "5432"

    password = "${ random_string.password.result }"

    tags
    {
        Name   = "postgres-db-${ var.in_ecosystem_name }-${ var.in_tag_timestamp }"
        Class = "${ var.in_ecosystem_name }"
        Desc   = "This RDS postgres database for ${ var.in_ecosystem_name } ${ var.in_tag_description }"
    }

}

/*
 | --
 | -- This multi-availability zone postgres database will be created within
 | -- the (usually) private subnets denoted by in_db_subnet_ids variable.
 | --
*/
resource aws_db_subnet_group object
{
    name_prefix = "db-${ var.in_ecosystem_name }"
    description = "RDS postgres subnet group for the ${ var.in_ecosystem_name } database."
    subnet_ids  = [ "${ var.in_db_subnet_ids }" ]

    tags
    {
        Name   = "db-subnet-group-${ var.in_ecosystem_name }-${ var.in_tag_timestamp }"
        Class = "${ var.in_ecosystem_name }"
        Desc   = "This RDS postgres database subnet group for ${ var.in_ecosystem_name } ${ var.in_tag_description }"
    }

}

/*
 | --
 | -- The Terraform generated database password will contain
 | -- 16 alphanumeric characters and no specials. Note that a fixed
 | -- password length greatly reduces the (brute force) search space.
 | --
*/
resource random_string password
{
    length  = 16
    upper   = true
    lower   = true
    number  = true
    special = false
}
