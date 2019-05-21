
variable in_security_group_id
{
    description = "The ID of the security group protecting the database."
}

variable in_db_subnet_ids
{
    type        = "list"
    description = "The subnet ids in which the multi-availability zone db resides."
}

variable in_database_name
{
    description = "The database name - a different name creates another database."
}

variable in_ecosystem_name
{
    description = "Creational stamp binding all infrastructure created for this ecosystem."
}

variable in_tag_timestamp
{
    description = "A timestamp for resource tags in the format ymmdd-hhmm like 80911-1435"
}

variable in_tag_description
{
    description = "Ubiquitous note detailing the who, when, where and why."
}