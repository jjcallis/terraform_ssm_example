# parameters / passwords for the database
resource "aws_ssm_parameter" "rds_aurora_db_url" {
  name        = "/example/${lower(var.environment)}/aurora/url"
  description = "the URL for example ${upper(var.environment)} DB"
  type        = "SecureString"
  value       = module.cluster.cluster_endpoint
  overwrite   = true
}

resource "aws_ssm_parameter" "rds_aurora_db_user" {
  name        = "/example/${lower(var.environment)}/aurora/username"
  description = "RDS Username for example ${upper(var.environment)} DB"
  type        = "SecureString"
  value       = var.rds_master_name
  overwrite   = true
}

resource "aws_ssm_parameter" "rds_aurora_db_name" {
  name        = "/example/${lower(var.environment)}/aurora/db"
  description = "The name of the database used for example ${upper(var.environment)} DB"
  type        = "SecureString"
  value       = var.rds_db_name
  overwrite   = true
}

resource "aws_ssm_parameter" "master_aurora_rds_password" {
  name        = "/example/${lower(var.environment)}/aurora/password"
  description = "Aurora RDS admin password for the example ${upper(var.environment)} DB"
  type        = "SecureString"
  value       = random_password.master_rds_password.result
  depends_on  = [random_password.master_rds_password]
  lifecycle {
    ignore_changes = [value]
  }
}

resource "random_password" "master_rds_password" {
  length            = 12
  special           = true
  min_lower         = 3
  min_numeric       = 3
  min_upper         = 3
  min_special       = 3
  override_special  = "!#$&()-_=+[]{}<>:?"
}
