
# Create PostgreSQL RDS Database | Terraform Module

Create a simple 32G AWS PostgreSQL RDS database. This module suits rapid proof of concept development - it is not designed to provision a production quality enterprise database.

The username is readwrite and the database listens on port 5432. Just provide a security group, private subnet ids, the database name and the ubiquitous tag information.

The only outputs needed are the out_database_hostname and the simple terraform generated out_database_password.

## Usage

    locals
    {
        ecosystem_name = "business-app"
    }

    module postgres_db
    {
        source     = "github.com/devops4me/terraform-aws-postgres-rds"
        in_security_group_id = "${ module.security-group.out_security_group_id }"
        in_db_subnet_ids = "${ module.vpc-network.out_private_subnet_ids }"

        in_database_name = "businessdata"

        in_ecosystem_name  = "${ local.ecosystem_name }"
        in_tag_timestamp   = "${ module.resource-tags.out_tag_timestamp }"
        in_tag_description = "${ module.resource-tags.out_tag_description }"
    }

    module vpc-network
    {
        source                 = "github.com/devops4me/terraform-aws-vpc-network"
        in_vpc_cidr            = "10.66.0.0/16"
        in_num_public_subnets  = 3
        in_num_private_subnets = 3

        in_ecosystem_name  = "${ local.ecosystem_name }"
        in_tag_timestamp   = "${ module.resource-tags.out_tag_timestamp }"
        in_tag_description = "${ module.resource-tags.out_tag_description }"
    }

    module security-group
    {
        source         = "github.com/devops4me/terraform-aws-security-group"
        in_ingress     = [ "ssh", "https",  ]
        in_vpc_id      = "${ module.vpc-network.out_vpc_id }"

        in_ecosystem_name  = "${ local.ecosystem_name }"
        in_tag_timestamp   = "${ module.resource-tags.out_tag_timestamp }"
        in_tag_description = "${ module.resource-tags.out_tag_description }"
    }

    module resource-tags
    {
        source = "github.com/devops4me/terraform-aws-resource-tags"
    }


The important outputs are the **out_database_hostname** and the terraform generated **out_database_password**.


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