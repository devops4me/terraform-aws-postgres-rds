
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

variable in_id_of_db_to_clone {
    description = "If the ID of mummy database to clone is omitted the parameter will not be set."
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
