
### ###################### ###
### in_publicly_accessible ###
### ###################### ###

variable in_publicly_accessible {
    description = "Make the RDS database publicly accessible inside a public subnet and appropriate security group."
    default = false
    type = bool
}


### #################### ###
### in_security_group_id ###
### #################### ###

variable in_security_group_id {
    description = "The mandatory ID of the security group protecting the database."
    type = string
}


### ################ ###
### in_db_subnet_ids ###
### ################ ###

variable in_db_subnet_ids {
    type = list
    description = "The usually two (2) or three (3) subnet ids in which the multi-availability zone db resides."
}


### ################ ###
### in_database_name ###
### ################ ###

variable in_database_name {
    description = "Alphanumeric only database name starting with a letter and a max length of 32."
    type = string
}


### ################# ###
### in_clone_snapshot ###
### ################# ###

variable in_clone_snapshot {
    description = "The newly Created database will be a clone from a snapshot if set to true."
    default = false
    type = bool
}

### #################### ###
### in_id_of_db_to_clone ###
### #################### ###

variable in_id_of_db_to_clone {
    description = "The ID of mummy database whose snapshot the database will be cloned from."
    default = ""
    type = string
}


### ################ ###
### in_mandated_tags ###
### ################ ###

variable in_mandated_tags {
    description = "Optional tags unless your organization mandates that a set of given tags must be set."
    type        = map
    default     = { }
}


### ############ ###
### in_ecosystem ###
### ############ ###

variable in_ecosystem {
    description = "Creational stamp binding all infrastructure components created on behalf of this ecosystem instance."
    default     = "app-db"
    type        = string
}


### ############ ###
### in_timestamp ###
### ############ ###

variable in_timestamp {
    description = "A timestamp for resource tags in the format ymmdd-hhmm like 80911-1435"
    default     = "TIMESTAMP"
    type = string
}


### ############## ###
### in_description ###
### ############## ###

variable in_description {
    description = "Ubiquitous note detailing who, when, where and why for every infrastructure component."
    default     = "within the AWS cloud at this point in time."
    type = string
}
