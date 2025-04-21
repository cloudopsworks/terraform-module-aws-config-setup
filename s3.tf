##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

resource "random_string" "random" {
  count   = var.random_bucket_suffix ? 1 : 0
  length  = 8
  special = false
  lower   = true
  upper   = false
  numeric = true
}

module "config_bucket" {
  source                                = "terraform-aws-modules/s3-bucket/aws"
  version                               = "~> 4.1"
  bucket                                = local.bucket_name
  acl                                   = "private"
  control_object_ownership              = true
  object_ownership                      = "ObjectWriter"
  force_destroy                         = false
  attach_deny_insecure_transport_policy = true
  block_public_acls                     = true
  block_public_policy                   = true
  ignore_public_acls                    = true
  restrict_public_buckets               = true
  versioning = {
    enabled = false
  }
  server_side_encryption_configuration = {
    rule = [
      {
        apply_server_side_encryption_by_default = {
          kms_master_key_id = aws_kms_key.config.arn
          sse_algorithm     = "aws:kms"
        }
      }
    ]
  }
  tags = local.all_tags
}