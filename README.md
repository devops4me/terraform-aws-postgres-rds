
# PostgreSQL RDS | Enterprise Grade | Terraform Module

Provision either a new **enterprise grade** PostgreSQL RDS database or **create a clone of another database from its snapshot**. In this context enterprise grade means
- a 48 long password chosen from a set of 70 characters
- a non predictable master database username string
- a high redundancy multi-availability zone database
- private subnet residency in a non-default VPC (if you so wish)
- behind the scenes encryption at rest
- robust options for backup (maintenance) windows and retention period
- sensible descriptive resource tags

## From Snapshot or New

This module will conditionally **instantiate from a snapshot** depending on a boolean variable that you provide.

## integration test | Jenkinsfile

This module comes with an **[integraion test](integration/postgres.test-main.tf)** and a Jenkinsfile so you know that it has been validated day in, day out. It doesn't grow stale and stop working like many other Terraform modules.

## Test Drive | Create Two Databases

Why not test drive this PostgreSQL terraform module.

```
git clone https://github.com/devops4me/terraform-aws-postgres-rds
cd terraform-aws-postgres-rds/integration
# Export your AWS Credentials and Region
terraform init
terraform deploy
```

## Usage | Creating New and Cloned Databases

This is a small insight 

```
    locals {
        ecosystem_name = "canary"
        fresh_db_name  = "freshdb"
        clone_db_name  = "clonedb"
    }

    module fresh_db {

        source = "github.com/devops4me/terraform-aws-postgres-rds"

        in_security_group_id = module.security-group.out_security_group_id
        in_db_subnet_ids     = module.vpc-network.out_private_subnet_ids
        in_database_name     = local.fresh_db_name

        in_ecosystem_name  = local.ecosystem_name
        in_tag_timestamp   = module.resource-tags.out_tag_timestamp
        in_tag_description = module.resource-tags.out_tag_description
    }

    module clone_db {

        source = "github.com/devops4me/terraform-aws-postgres-rds"

        in_security_group_id = module.security-group.out_security_group_id
        in_db_subnet_ids     = module.vpc-network.out_private_subnet_ids
        in_id_of_db_to_clone = var.in_id_of_db_to_clone
        in_clone_snapshot = true

        in_database_name = local.clone_db_name

        in_ecosystem_name  = local.ecosystem_name
        in_tag_timestamp   = module.resource-tags.out_tag_timestamp
        in_tag_description = module.resource-tags.out_tag_description
    }
```

The important outputs are the **out_database_hostname**, **out_database_username** and the **out_database_password**.

Look at the integration test for the bells and whistles that terraform demands.

---

## Inputs

This AWS PostgreSQL database terraform module requires these input variables.
**Important - the database name must start with a letter (not a digit) and can only contain alphanumerics.**

| Imported | Type | Comment |
|:-------- |:---- |:------- |
**in_security_group_id** | String | security group constraining database traffic flows
**in_db_subnet_ids** | List | private subnet IDs in which to create the database
**in_database_name** | String | alphanumeric only name to give the new database


## Outputs

| Exported                 | Type   | Comment |
|:------------------------ |:------ |:------- |
**out_database_hostname**  | String | The addressable hostname of the database
**out_database_password**  | String | password protecting the database account


### Contributing

Bug reports and pull requests are welcome on GitHub at the https://github.com/devops4me/terraform-aws-postgres-rds page. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

License
-------

MIT License
Copyright (c) 2006 - 2014

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.