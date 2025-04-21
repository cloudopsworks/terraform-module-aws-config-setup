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
    sid = "AllowAdminToRoot"
    actions = [
      "kms:ListAliases",
      "kms:ListGrants",
      "kms:ListKeyPolicies",
      "kms:ListResourceTags",
      "kms:GetKeyPolicy",
      "kms:GetKeyRotationStatus",
      "kms:GetPublicKey",
      "kms:DescribeKey"
    ]
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
      ]
    }
  }
}

resource "aws_kms_key" "config" {
  description             = "KMS key for AWS Config"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  is_enabled              = true
  key_usage               = "ENCRYPT_DECRYPT"
  policy                  = data.aws_iam_policy_document.config_kms.json
  tags                    = local.all_tags
}

resource "aws_kms_alias" "config" {
  name          = "alias/${local.clean_name}"
  target_key_id = aws_kms_key.config.key_id
}
