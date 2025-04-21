##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

# KMS Key policy, to allow AWS Config make use of the KMS key
data "aws_iam_policy_document" "config_kms" {
  statement {
    sid = "AWSConfig"
    actions = [
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:Encrypt",
      "kms:GenerateDataKey*",
      "kms:ReEncrypt*",
      "kms:CreateGrant",
      "kms:ListGrants",
      "kms:RevokeGrant"
    ]
    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "kms:ViaService"
      values   = ["${data.aws_partition.current.dns_suffix}"]
    }
  }
  statement {
    sid    = "AllowAdminToRoot"
    effect = "Allow"
    actions = [
      "kms:*",
    ]
    principals {
      type = "AWS"
      identifiers = concat([
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
        ],
        try(var.settings.additional_kms_admins, [])
      )
    }
    resources = [
      "*"
    ]
  }
  statement {
    sid    = "UseAccounts"
    effect = "Allow"
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey*",

    ]
    principals {
      type = "AWS"
      identifiers = [
        data.aws_caller_identity.current.account_id
      ]
    }
    resources = [
      aws_kms_key.config.arn
    ]
  }
}

resource "aws_kms_key" "config" {
  description             = "KMS key for AWS Config"
  deletion_window_in_days = 15
  enable_key_rotation     = true
  is_enabled              = true
  key_usage               = "ENCRYPT_DECRYPT"
  tags                    = local.all_tags
}

resource "aws_kms_key_policy" "config" {
  key_id = aws_kms_key.config.key_id
  policy = data.aws_iam_policy_document.config_kms.json
}
resource "aws_kms_alias" "config" {
  name          = "alias/${local.clean_name}"
  target_key_id = aws_kms_key.config.key_id
}
