##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

resource "aws_sns_topic" "config_sns" {
  name              = local.sns_name
  display_name      = "Config SNS Topic - ${local.sns_name}"
  kms_master_key_id = aws_kms_key.config.id
  tags              = local.all_tags
}

data "aws_iam_policy_document" "config_sns" {
  statement {
    effect = "Allow"
    actions = [
      "sns:Publish"
    ]
    principals {
      type = "AWS"
      identifiers = [
        data.aws_caller_identity.current.account_id
      ]
    }
    resources = [
      aws_sns_topic.config_sns.arn
    ]
  }
}

resource "aws_sns_topic_policy" "config_sns" {
  arn    = aws_sns_topic.config_sns.arn
  policy = data.aws_iam_policy_document.config_sns.json
}