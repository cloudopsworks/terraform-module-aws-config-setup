##
# (c) 2021-2025
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

resource "aws_iam_service_linked_role" "config" {
  count            = var.is_hub || try(var.settings.service_role, false) ? 1 : 0
  aws_service_name = "config.amazonaws.com"
  tags             = local.all_tags
}

data "aws_iam_policy_document" "config_assume_role_policy" {
  count = var.is_hub ? 1 : 0
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type = "Service"
      identifiers = [
        "config.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "this" {
  count              = var.is_hub ? 1 : 0
  name               = "${local.clean_name}-role"
  description        = "AWS Config role for ${local.clean_name}"
  path               = "/service-role/config.amazonaws.com/"
  assume_role_policy = data.aws_iam_policy_document.config_assume_role_policy[count.index].json
  tags               = local.all_tags
}

data "aws_iam_policy_document" "config_s3_policy" {
  count = var.is_hub ? 1 : 0
  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:DeleteObject",
      "s3:GetBucketAcl",
    ]
    resources = [
      "${module.config_bucket[count.index].s3_bucket_arn}/*",
      module.config_bucket[count.index].s3_bucket_arn
    ]
  }
}

data "aws_iam_policy_document" "config_sns_policy" {
  count = (var.is_hub || try(var.settings.create_recorder, false)) && try(var.settings.sns_enabled, true) ? 1 : 0
  statement {
    effect = "Allow"
    actions = [
      "sns:Publish"
    ]
    resources = [
      aws_sns_topic.config_sns[0].arn
    ]
  }
}

data "aws_iam_policy_document" "config_kms_policy" {
  count = var.is_hub ? 1 : 0
  statement {
    effect = "Allow"
    actions = [
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:Encrypt",
      "kms:GenerateDataKey*",
      "kms:ReEncrypt*",
      "kms:CreateGrant",
    ]
    resources = [
      aws_kms_key.config[count.index].arn
    ]
  }
}

resource "aws_iam_policy" "config_s3_policy" {
  count  = var.is_hub ? 1 : 0
  name   = "${local.clean_name}-s3-policy"
  path   = "/service-role/config.amazonaws.com/"
  policy = data.aws_iam_policy_document.config_s3_policy[count.index].json
}

resource "aws_iam_role_policy_attachment" "config_s3_policy" {
  count      = var.is_hub ? 1 : 0
  role       = aws_iam_role.this[count.index].id
  policy_arn = aws_iam_policy.config_s3_policy[count.index].arn
}

resource "aws_iam_policy" "config_sns_policy" {
  count  = (var.is_hub || try(var.settings.create_recorder, false)) && try(var.settings.sns_enabled, true) ? 1 : 0
  name   = "${local.clean_name}-sns-policy"
  path   = "/service-role/config.amazonaws.com/"
  policy = data.aws_iam_policy_document.config_sns_policy[count.index].json
}

resource "aws_iam_role_policy_attachment" "config_sns_policy" {
  count      = (var.is_hub || try(var.settings.create_recorder, false)) && try(var.settings.sns_enabled, true) ? 1 : 0
  role       = aws_iam_role.this[count.index].id
  policy_arn = aws_iam_policy.config_sns_policy[count.index].arn
}

resource "aws_iam_policy" "config_kms_policy" {
  count  = var.is_hub ? 1 : 0
  name   = "${local.clean_name}-kms-policy"
  path   = "/service-role/config.amazonaws.com/"
  policy = data.aws_iam_policy_document.config_kms_policy[count.index].json
}

resource "aws_iam_role_policy_attachment" "config_kms_policy" {
  count      = var.is_hub ? 1 : 0
  role       = aws_iam_role.this[count.index].id
  policy_arn = aws_iam_policy.config_kms_policy[count.index].arn
}

resource "aws_iam_role" "config_aggregator" {
  count              = var.is_hub ? 1 : 0
  name               = "${local.clean_name}-org-role"
  description        = "AWS Config role for ${local.clean_name} - Organization Access"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.config_assume_role_policy[count.index].json
  tags               = local.all_tags
}

resource "aws_iam_role_policy_attachment" "config_aggregator" {
  count      = var.is_hub ? 1 : 0
  role       = aws_iam_role.config_aggregator[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRoleForOrganizations"
}