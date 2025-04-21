##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

# KMS Key policy, to allow AWS Config make use of the KMS key
data "aws_iam_policy_document" "config_kms" {
  count = var.is_hub ? 1 : 0
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
      identifiers = concat([
        data.aws_caller_identity.current.account_id
        ],
        try(var.settings.additional_accounts_access, [])
      )
    }
    resources = [
      aws_kms_key.config[count.index].arn
    ]
  }
}

resource "aws_kms_key" "config" {
  count                   = var.is_hub ? 1 : 0
  description             = "KMS key for AWS Config"
  deletion_window_in_days = 15
  enable_key_rotation     = true
  is_enabled              = true
  key_usage               = "ENCRYPT_DECRYPT"
  tags                    = local.all_tags
}

resource "aws_kms_key_policy" "config" {
  count  = var.is_hub ? 1 : 0
  key_id = aws_kms_key.config[count.index].key_id
  policy = data.aws_iam_policy_document.config_kms[count.index].json
}
resource "aws_kms_alias" "config" {
  count         = var.is_hub ? 1 : 0
  name          = "alias/${local.clean_name}"
  target_key_id = aws_kms_key.config[count.index].key_id
}
