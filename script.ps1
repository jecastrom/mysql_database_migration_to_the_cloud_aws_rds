### MySQL Shell commands

mysqlsh # manual change
\connect jorge@localhost

# For scripting:

$user = 'jcastro'
$pass = 'my-password'
$host_ = 'localhost'

$mysql = 'C:\Program Files\MySQL\MySQL Shell 8.0\bin\mysqlsh.exe'
$params = '-u', $user, '-h', $host_, '-p', $pass










# Creating the dump with the utilility dump Schemas:

util.dumpSchemas(["sakila"], "backup-sak-aws", { routines:true, compatibility: ["strip_definers", "strip_restricted_grants"] })



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