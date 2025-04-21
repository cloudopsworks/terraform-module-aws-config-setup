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

data "aws_iam_policy_document" "config_bucket_policy" {
  statement {
    sid    = "AWSConfigBucketPermissionsCheck"
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = [
        "config.amazonaws.com"
      ]
    }
    actions = [
      "s3:GetBucketAcl"
    ]
    resources = [
      "aws:s3:::${local.bucket_name}"
    ]
  }
  statement {
    sid    = "AWSConfigBucketExistenceCheck"
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = [
        "config.amazonaws.com"
      ]
    }
    actions = [
      "s3:ListBucket"
    ]
    resources = [
      "aws:s3:::${local.bucket_name}"
    ]
  }
  statement {
    sid    = "AWSConfigBucketDelivery"
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = [
        "config.amazonaws.com"
      ]
    }
    actions = [
      "s3:PutObject"
    ]
    resources = [
      try(var.settings.s3_prefix, "") != "" ? "aws:s3:::${local.bucket_name}/${var.settings.s3_prefix}/AWSLogs/${data.aws_caller_identity.current.account_id}/Config/*" :
      "aws:s3:::${local.bucket_name}/AWSLogs/${data.aws_caller_identity.current.account_id}/Config/*"
    ]
  }
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
  policy                                = data.aws_iam_policy_document.config_bucket_policy.json
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