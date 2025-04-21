##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

locals {
  clean_name  = var.short_system_name == true ? "${var.name_prefix}-config-${local.system_name_short}" : "${var.name_prefix}-config-${local.system_name}"
  bucket_name = var.random_bucket_suffix == false ? local.clean_name : "${local.clean_name}-${random_string.random[0].result}"
  sns_name    = var.short_system_name == true ? "${var.name_prefix}-config-sns-${local.system_name_short}" : "${var.name_prefix}-config-sns-${local.system_name}"
}

resource "aws_config_configuration_recorder" "this" {
  name     = local.clean_name
  role_arn = try(var.settings.service_role, false) ? aws_iam_service_linked_role.config[0].arn : aws_iam_role.this[0].arn
}

resource "aws_config_delivery_channel" "this" {
  name           = local.clean_name
  s3_bucket_name = var.is_hub ? module.config_bucket[0].s3_bucket_id : var.settings.s3_bucket_name
  s3_key_prefix  = try(var.settings.s3_prefix, "")
  s3_kms_key_arn = var.is_hub ? aws_kms_key.config[0].arn : var.settings.s3_kms_key_arn
  sns_topic_arn  = aws_sns_topic.config_sns.arn
  snapshot_delivery_properties {
    delivery_frequency = try(var.settings.delivery_frequency, "TwentyFour_Hours")
  }
  depends_on = [
    module.config_bucket,
    aws_config_configuration_recorder.this
  ]
}

resource "aws_config_configuration_recorder_status" "this" {
  name       = aws_config_configuration_recorder.this.name
  is_enabled = try(var.settings.recorder_enabled, true)
  depends_on = [
    aws_config_delivery_channel.this
  ]
}

resource "aws_config_retention_configuration" "this" {
  retention_period_in_days = try(var.settings.retention_period_in_days, 365)
}