### MySQL Shell commands

mysqlsh # manual change
\connect jorge@localhost

# For scripting:

$user = 'jcastro'
$pass = 'my-password'
$host_ = 'localhost'

$mysqlsh = 'C:\Program Files\MySQL\MySQL Shell 8.0\bin\mysqlsh.exe'
$params = '-u', $user, '-h', $host_, '-p', $pass



# Creating the dump with the utilility dump Schemas:

& $mysqlsh @params -e util.dumpSchemas(["sakila"], "backup-sak-aws", { routines:true, compatibility: ["strip_definers", "strip_restricted_grants"] })



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



# As we have already created for the first time the "SUPER" user --paramater-group, we can go straight to
# associate the --paramater-group.


aws rds modify-db-instance `
    --db-instance-identifier "sakila-aws" `
    --db-parameter-group-name "superuser"




# We have already added the inbound rule to the security group, so the subsecuent RDS created have already 
# the ingress trafic rule (authorize our IP to connect)




# Loading (Restoring) the database to AWS RDS (MySQL Shell JS mode)

# We loggin with our AWS RDS credentials


$user = 'admindb'
$pass = 'my-password'
$host_ = 'sakita-aws.cxrxxxxxiav1.eu-central-l.rds.amazonaws.com'

$mysqlsh = 'C:\Program Files\MySQL\MySQL Shell 8.0\bin\mysqlsh.exe'
$params = '-u', $user, '-h', $host_, '-p', $pass


& $mysqlsh @params -e util.loadDump("sakila-aws", { threads: 16, deferTableIndexes: "all" })

************************************************


