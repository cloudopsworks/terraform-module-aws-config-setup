##
# (c) 2021-2025
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

resource "aws_sns_topic" "config_sns" {
  count        = (var.is_hub || try(var.settings.create_recorder, false)) && try(var.settings.sns_enabled, true) ? 1 : 0
  name         = local.sns_name
  display_name = "Config SNS Topic - ${local.sns_name}"
  tags         = local.all_tags
}

data "aws_iam_policy_document" "config_sns" {
  count = (var.is_hub || try(var.settings.create_recorder, false)) && try(var.settings.sns_enabled, true) ? 1 : 0
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
      aws_sns_topic.config_sns[0].arn
    ]
  }
}

resource "aws_sns_topic_policy" "config_sns" {
  count  = (var.is_hub || try(var.settings.create_recorder, false)) && try(var.settings.sns_enabled, true) ? 1 : 0
  arn    = aws_sns_topic.config_sns[0].arn
  policy = data.aws_iam_policy_document.config_sns[0].json
}