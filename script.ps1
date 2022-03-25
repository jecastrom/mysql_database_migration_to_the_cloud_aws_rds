### MySQL Shell commands

mysqlsh



# Logging in to MySQL Shell

\connect jorge@localhost



# Creating the dump with the utilility dump Schemas:

util.dumpSchemas(["sakila"], "backup-sak-aws", { routines:true, `
            compatibility: ["strip_definers", "strip_restricted_grants"] })



# Provisioning the RDS instance

aws rds create-db-instance `
    --db-instance-identifier sakila-aws `
    --db-instance-class db.t2.micro `
    --engine mysql `
    --master-username "admindb" `
    --master-user-password "my-password" `
    --engine-version 8.0.26 `
    --storage-type gp2 `
    --publicly-accessible `
    --allocated-storage 20 | `
    aws rds wait db-instance-available `
    --db-instance-identifier sakila-aws | `
    aws rds describe-db-instances `
    --db-instance-identifier sakila-aws `
    --query "DBInstances[*].[Engine,DBInstanceIdentifier,EngineVersion,DBInstanceStatus,`
    Endpoint.Address,AllocatedStorage,DBInstanceClass,MasterUsername,Endpoint.Port]"