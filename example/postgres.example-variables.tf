
/*
 | --
 | -- If cloning the database then the module needs to know the RDS ID of
 | -- the database whose last available snapshot will be sought after.
 | --
*/
variable in_id_of_db_to_clone {
    description = "The ID of mummy database to clone from."
}


/*
 | --
 | -- You must state whether you want the created databases to be publicly
 | -- accessible or not. If yes then the database must live in public subnets.
 | --
*/
variable in_publicly_accessible {
    description = "Make the RDS database publicly accessible inside a public subnet and appropriate security group."
    type = bool
}


/*
 | --
 | -- If you are using an IAM role as the AWS access mechanism then
 | -- pass it as in_role_arn commonly through an environment variable
 | -- named TF_VAR_in_role_arn in addition to the usual AWS access
 | -- key, secret key and default region parameters.
 | --
*/
variable in_role_arn {
    description = "The Role ARN to use when we assume role to implement the provisioning."
    default = ""
}
