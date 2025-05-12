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
  count = var.is_hub ? 1 : 0
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
      "arn:aws:s3:::${local.bucket_name}"
    ]
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceAccount"
      values = concat([
        data.aws_caller_identity.current.account_id
        ],
        try(var.settings.additional_accounts_access, [])
      )
    }
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
      "arn:aws:s3:::${local.bucket_name}"
    ]
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceAccount"
      values = concat([
        data.aws_caller_identity.current.account_id
        ],
        try(var.settings.additional_accounts_access, [])
      )
    }
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
    resources = concat([
      try(var.settings.s3_prefix, "") != "" ? "arn:aws:s3:::${local.bucket_name}/${var.settings.s3_prefix}/AWSLogs/${data.aws_caller_identity.current.account_id}/Config/*" :
      "arn:aws:s3:::${local.bucket_name}/AWSLogs/${data.aws_caller_identity.current.account_id}/Config/*"
      ],
      [
        for access_account in try(var.settings.additional_accounts_access, []) : "arn:aws:s3:::${local.bucket_name}/AWSLogs/${access_account}/Config/*"
    ])
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceAccount"
      values = concat([
        data.aws_caller_identity.current.account_id
        ],
        try(var.settings.additional_accounts_access, [])
      )
    }
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values = [
        "bucket-owner-full-control"
      ]
    }
  }
}

module "config_bucket" {
  count                                 = var.is_hub ? 1 : 0
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
  attach_policy                         = true
  policy                                = data.aws_iam_policy_document.config_bucket_policy[0].json
  versioning = {
    enabled = false
  }
  server_side_encryption_configuration = {
    rule = [
      {
        apply_server_side_encryption_by_default = {
          kms_master_key_id = aws_kms_key.config[0].arn
          sse_algorithm     = "aws:kms"
        }
      }
    ]
  }
  tags = local.all_tags
}