##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

resource "aws_iam_service_linked_role" "config" {
  aws_service_name = "config.amazonaws.com"
  #custom_suffix    = local.clean_name
  tags = local.all_tags
}

data "aws_iam_policy_document" "config_assume_role_policy" {
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
  name               = "${local.clean_name}-role"
  assume_role_policy = data.aws_iam_policy_document.config_assume_role_policy.json
  tags               = local.all_tags
}

data "aws_iam_policy_document" "config_s3_policy" {
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
      "${module.config_bucket.s3_bucket_arn}/*",
      module.config_bucket.s3_bucket_arn
    ]
  }
}

data "aws_iam_policy_document" "config_sns_policy" {
  statement {
    effect = "Allow"
    actions = [
      "sns:Publish"
    ]
    resources = [
      aws_sns_topic.config_sns.arn
    ]
  }
}

data "aws_iam_policy_document" "config_kms_policy" {
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
      aws_kms_key.config.arn
    ]
  }
}

resource "aws_iam_role_policy" "config_s3_policy" {
  name   = "${local.clean_name}-s3-policy"
  role   = aws_iam_role.this.id
  policy = data.aws_iam_policy_document.config_s3_policy.json
}

resource "aws_iam_role_policy" "config_sns_policy" {
  name   = "${local.clean_name}-sns-policy"
  role   = aws_iam_role.this.id
  policy = data.aws_iam_policy_document.config_sns_policy.json
}

resource "aws_iam_role_policy" "config_kms_policy" {
  name   = "${local.clean_name}-kms-policy"
  role   = aws_iam_role.this.id
  policy = data.aws_iam_policy_document.config_kms_policy.json
}

resource "aws_iam_role_policy_attachment" "config_policy" {
  role       = aws_iam_role.this.id
  policy_arn = "arn:aws:iam::aws:policy/aws-service-role/AWSConfigServiceRolePolicy"
}