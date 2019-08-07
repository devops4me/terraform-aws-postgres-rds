
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

variable in_ecosystem_name {
    description = "Creational stamp binding all infrastructure created for this ecosystem."
}

variable in_tag_timestamp {
    description = "Ubiquitous alphanumeric timestamp for resource tags like 909081716 ( YMMDDhhmm ) for 9th Nov 2019 at 5:16 pm."
}

variable in_tag_description {
    description = "Ubiquitous description for resource tags detailing who created the resource and when, where and why."
}
