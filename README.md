
# PostgreSQL RDS | Create from Snapshot or Create New

Provision _either_ a new **enterprise grade** PostgreSQL RDS database _or_ **create a clone of another database from its snapshot**. In this context enterprise grade means
- a 48 long password chosen from a set of 70 characters
- a non predictable master database username string
- a high redundancy multi-availability zone database
- private subnet residency in a non-default VPC (if you so wish)
- behind the scenes encryption at rest
- robust options for backup (maintenance) windows and retention period
- sensible descriptive resource tags


---


## Module Usage | Create New and/or Cloned RDS DBs

This module will conditionally **instantiate from a snapshot** depending on whether **`var.in_clone_snapshot`** is true or false. If true the RDS ID of the database to clone must be provided. This last available snapshot is chosen as the baseline for creating the cloned database.

```
    module fresh_db {

        source                 = "devops4me/postgres-rds/aws"
        version                = "1.0.1"

        in_security_group_id = module.security-group.out_security_group_id
        in_db_subnet_ids     = module.vpc-network.out_private_subnet_ids
        in_database_name     = "fresh_db"
    }

    module clone_db {

        source                 = "devops4me/postgres-rds/aws"
        version                = "1.0.1"

        in_clone_snapshot    = true
        in_id_of_db_to_clone = var.in_id_of_db_to_clone

        in_security_group_id = module.security-group.out_security_group_id
        in_db_subnet_ids     = module.vpc-network.out_private_subnet_ids
        in_database_name     = "cloned_db"
    }
```

The important outputs are the **out_database_hostname**, **out_database_username** and the **out_database_password**.

Look at the integration test for the bells and whistles that terraform demands.


---


## Inputs

This AWS PostgreSQL database terraform module requires these input variables.
**Important - the database name must start with a letter (not a digit) and can only contain alphanumerics.**

| Input Variable | Type | Comment |
|:-------- |:---- |:------- |
**in_database_name** | String | **alphanumeric only name** to give the new database and it must start with a letter - note that providing a different name causes terraform to create a different database
**in_clone_snapshot** | Boolean | if true the in_id_of_db_to_clone must be provided and will cause the database to be created from the last available snapshot of the specified database
**in_id_of_db_to_clone** | String | this ID must be provided if **`in_clone_snapshot`** is true causing the database to be created from the last available snapshot
**in_security_group_id** | String | the security group that will constrain traffic to and from the  database
**in_db_subnet_ids** | List | list of private subnet IDs in at least two availability zones (see example) for housing database instances


### Resource Tag Inputs

Most organisations have a mandatory set of tags that must be placed on AWS resources for cost and billing reports. Typically they denote owners and specify whether environments are prod or non-prod.


Additionally you can denote 

| Input Variable    | Variable Description | Input Example
|:----------------- |:-------------------- |:----- |
**`in_ecosystem`** | the ecosystem (environment) name these resources belong to | **`my-app-test`** or **`kubernetes-cluster`**
**`in_timestamp`** | the timestamp in resource names helps you identify which environment instance resources belong to | **`1911021435`** as **`$(date +%y%m%d%H%M%S)`**
**`in_description`** | a human readable description usually stating who is creating the resource and when and where | "was created by $USER@$HOSTNAME on $(date)."

Try **`echo $(date +%y%m%d%H%M%S)`** to check your timestamp and **`echo "was created by $USER@$HOSTNAME on $(date)."`** to check your description. Here is how you can send these values to terraform.

```
$ export TF_VAR_in_timestamp=$(date +%y%m%d%H%M%S)
$ export TF_VAR_in_description="was created by $USER@$HOSTNAME on $(date)."
```

## Outputs

| Output Variable          | Type   | Comment |
|:------------------------ |:------ |:------- |
**out_database_username**  | String | The first database username prefixed with user_rw_ followed by randomized characters.
**out_database_password**  | String | Robust terraform created 48 character password that includes the allowed special characters
**out_clone_db_hostname**  | String | The addressable hostname of the database that has been cloned from a snapshot
**out_clone_db_endpoint**  | String | The database endpoint with protool suffix of the database that has been cloned from a snapshot
**out_fresh_db_hostname**  | String | The addressable hostname of the newly created (fresh) database
**out_fresh_db_endpoint**  | String | The database endpoint with protool suffix of the newly created (fresh) database
