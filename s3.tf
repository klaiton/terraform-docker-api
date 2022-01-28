resource "aws_s3_bucket" "lb_access_logs" {
  bucket = local.log_bucket
  acl    = "private"
  force_destroy = true
  policy = data.template_file.s3_policy.rendered
    tags = {
    Name        = "access-logs-${local.env}"
    Environment = local.env
    Project     = var.project
  }
}

#Cria uma policy definindo as permissões do bucket a partir de um template
data "template_file" "s3_policy" {
  template = file("templates/s3_policy.tmpl")
  vars = {
    ACCOUNT_ID  = var.lb_account_id,
    BUCKET_NAME = local.log_bucket,
    PREFIX      = var.access_log_prefix
  }
}