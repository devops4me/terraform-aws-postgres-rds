
variable in_security_group_id {
    description = "The ID of the security group protecting the database."
}


variable in_db_subnet_ids {
    type = "list"
    description = "The subnet ids in which the multi-availability zone db resides."
}


variable in_database_name {
    description = "Alphanumeric only database name starting with a letter and a max length of 32."
}


variable in_clone_snapshot {
    description = "The newly Created database will be a clone from a snapshot if set to true."
    default = false
}

variable in_id_of_db_to_clone {
    description = "The ID of mummy database whose snapshot the database will be cloned from."
    default = ""
}

### ############################## ###
### [[variable]] in_mandated_tags ###
### ############################## ###

variable in_mandated_tags {

    description = "Optional tags unless your organization mandates that a set of given tags must be set."
    type        = map
    default     = { }
}


### ################# ###
### in_ecosystem ###
### ################# ###

variable in_ecosystem {

    description = "Creational stamp binding all infrastructure components created on behalf of this ecosystem instance."
}


### ################ ###
### in_timestamp ###
### ################ ###

variable in_timestamp {

    description = "A timestamp for resource tags in the format ymmdd-hhmm like 80911-1435"
}


### ################## ###
### in_description ###
### ################## ###

variable in_description {

    description = "Ubiquitous note detailing who, when, where and why for every infrastructure component."
}
