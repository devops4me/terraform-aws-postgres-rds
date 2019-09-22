
### ############################ ###
### Example RDS Postgres Outputs ###
### ############################ ###

output out_fresh_database_hostname {
    value = module.fresh_db.out_fresh_db_hostname
}

output out_fresh_database_username {
    value = module.fresh_db.out_database_username
}

output out_fresh_database_password {
    value = module.fresh_db.out_database_password
}

output out_clone_database_hostname {
    value = module.clone_db.out_clone_db_hostname
}

output out_clone_database_username {
    value = module.clone_db.out_database_username
}

output out_clone_database_password {
    value = module.clone_db.out_database_password
}
