
variable in_security_group_id {
    description = "The ID of the security group protecting the database."
}

variable in_db_subnet_ids {
    type = "list"
    description = "The subnet ids in which the multi-availability zone db resides."
}

variable in_database_name {
    description = "The database name remembering that a different name creates another database."
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
### [[variable]] in_mandatory_tags ###
### ############################## ###

variable in_mandatory_tags {

    description = "Optional tags unless your organization mandates that a set of given tags must be set."
    type        = map
    default     = { }
}


### ################# ###
### in_ecosystem_name ###
### ################# ###

variable in_ecosystem_name {

    description = "Creational stamp binding all infrastructure components created on behalf of this ecosystem instance."
}


### ################ ###
### in_tag_timestamp ###
### ################ ###

variable in_tag_timestamp {

    description = "A timestamp for resource tags in the format ymmdd-hhmm like 80911-1435"
}


### ################## ###
### in_tag_description ###
### ################## ###

variable in_tag_description {

    description = "Ubiquitous note detailing who, when, where and why for every infrastructure component."
}
