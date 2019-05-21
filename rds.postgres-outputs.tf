
/*
 | --
 | -- These are the postgres database output variables.
 | -- The database username and password are not involved here
 | -- because they are consumed ( as opposed to produced ).
 | --
*/
output out_database_hostname { value = "${ aws_db_instance.postgres.address }" }
output out_database_endpoint { value = "${ aws_db_instance.postgres.endpoint }" }
output out_database_password { value = "${ random_string.password.result }" }
