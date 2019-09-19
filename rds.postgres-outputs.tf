
output out_database_username {
    value = local.db_username
}

output out_database_password {
    value = random_string.dbpassword.result
}

output out_fresh_db_hostname {
    value = length( aws_db_instance.fresh ) == 0 ? "n/a" : aws_db_instance.fresh[0].address
}

output out_fresh_db_endpoint {
    value = length( aws_db_instance.fresh ) == 0 ? "n/a" : aws_db_instance.fresh[0].endpoint
}

output out_clone_db_hostname {
    value = length( aws_db_instance.clone ) == 0 ? "n/a" : aws_db_instance.clone[0].address
}

output out_clone_db_endpoint {
    value = length( aws_db_instance.clone ) == 0 ? "n/a" : aws_db_instance.clone[0].endpoint
}

