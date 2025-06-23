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
  count = var.is_hub || try(var.settings.create_recorder, false) ? 1 : 0
  name  = try(var.settings.custom, false) ? local.clean_name : "default"
  role_arn = try(var.settings.service_role_arn,
    try(var.settings.service_role, false) ? aws_iam_service_linked_role.config[0].arn : aws_iam_role.this[0].arn
  )
  recording_group {
    all_supported                 = try(var.settings.recording.all_supported, true)
    resource_types                = try(var.settings.recording.resource_types, null)
    include_global_resource_types = try(var.settings.recording.include_global_resource_types, null)
    dynamic "exclusion_by_resource_types" {
      for_each = length(try(var.settings.recording.exclusion_by_resource_types, [])) > 0 ? [1] : []
      content {
        resource_types = var.settings.recording.exclusion_by_resource_types
      }
    }
    recording_strategy {
      use_only = try(var.settings.recording.use_only, null)
    }
  }
  recording_mode {
    recording_frequency = try(var.settings.recording.recording_frequency, "CONTINUOUS")
    dynamic "recording_mode_override" {
      for_each = length(try(var.settings.recording.override, {})) > 0 ? [1] : []
      content {
        description         = try(var.settings.recording.override.description, null)
        resource_types      = var.settings.recording.override.resource_types
        recording_frequency = try(var.settings.recording.override.recording_frequency, "CONTINUOUS")
      }
    }
  }
}

data "aws_kms_alias" "config" {
  count = var.is_hub == false && try(var.settings.kms.alias, "") != "" ? 1 : 0
  name  = var.settings.kms.alias
}

resource "aws_config_delivery_channel" "this" {
  name           = try(var.settings.custom, false) ? local.clean_name : "default"
  s3_bucket_name = var.is_hub ? module.config_bucket[0].s3_bucket_id : var.settings.s3_bucket_name
  s3_key_prefix  = try(var.settings.s3_prefix, "")
  s3_kms_key_arn = var.is_hub ? aws_kms_key.config[0].arn : try(data.aws_kms_alias.config[0].target_key_arn, aws_kms_replica_key.config[0].arn, var.settings.kms.key_arn)
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
  count      = var.is_hub || try(var.settings.create_recorder, false) ? 1 : 0
  name       = aws_config_configuration_recorder.this[0].name
  is_enabled = try(var.settings.recorder_enabled, true)
  depends_on = [
    aws_config_delivery_channel.this
  ]
}

resource "aws_config_retention_configuration" "this" {
  retention_period_in_days = try(var.settings.retention_period_in_days, 365)
}

resource "aws_config_configuration_aggregator" "this" {
  for_each = {
    for item in try(var.settings.aggregators, []) : item.name => item
    if var.is_hub
  }
  name = each.value.name
  dynamic "account_aggregation_source" {
    for_each = length(try(each.value.account, [])) > 0 ? [1] : []
    content {
      account_ids = try(each.value.account.account_ids, null)
      all_regions = try(each.value.account.all_regions, null)
      regions     = try(each.value.account.regions, null)
    }
  }
  dynamic "organization_aggregation_source" {
    for_each = length(try(each.value.organization, [])) > 0 ? [1] : []
    content {
      all_regions = try(each.value.organization.all_regions, null)
      regions     = try(each.value.organization.regions, null)
      role_arn    = aws_iam_role.config_aggregator[0].arn
    }
  }
  tags = local.all_tags
}

resource "aws_organizations_delegated_administrator" "this" {
  count             = try(var.settings.organization.delegated, false) ? 1 : 0
  account_id        = var.settings.organization.account_id
  service_principal = "config.amazonaws.com"
}

resource "aws_config_organization_conformance_pack" "org_config" {
  for_each = {
    for item in try(var.settings.organization.conformance_packs, []) : item.name => item
    if var.is_hub
  }
  name                   = each.value.name
  template_body          = try(each.value.template_body, null)
  template_s3_uri        = try(each.value.template_s3_uri, null)
  delivery_s3_bucket     = local.bucket_name
  delivery_s3_key_prefix = try(each.value.delivery_s3_key_prefix, "conformance-pack/${each.key}")
  excluded_accounts      = try(each.value.excluded_accounts, null)
  dynamic "input_parameter" {
    for_each = try(each.value.input_parameters, [])
    content {
      parameter_name  = input_parameter.value.name
      parameter_value = input_parameter.value.value
    }
  }
  depends_on = [aws_config_configuration_recorder.this]
}

resource "aws_config_organization_managed_rule" "org_config" {
  for_each = {
    for item in try(var.settings.organization.managed_rules, []) : item.name => item
    if var.is_hub
  }
  name                        = each.value.name
  description                 = try(each.value.description, null)
  rule_identifier             = each.value.rule_identifier
  excluded_accounts           = try(each.value.excluded_accounts, null)
  input_parameters            = try(each.value.input_parameters, null)
  maximum_execution_frequency = try(each.value.maximum_execution_frequency, null)
  resource_id_scope           = try(each.value.resource_id_scope, null)
  resource_types_scope        = try(each.value.resource_types_scope, null)
  tag_key_scope               = try(each.value.tag_key_scope, null)
  tag_value_scope             = try(each.value.tag_value_scope, null)
}

resource "aws_config_organization_custom_rule" "org_config" {
  for_each = {
    for item in try(var.settings.organization.custom_rules, []) : item.name => item
    if var.is_hub
  }
  name                        = each.value.name
  description                 = try(each.value.description, null)
  lambda_function_arn         = each.value.lambda_function_arn
  trigger_types               = try(each.value.trigger_types, ["ConfigurationItemChangeNotification"])
  excluded_accounts           = try(each.value.excluded_accounts, null)
  input_parameters            = try(each.value.input_parameters, null)
  maximum_execution_frequency = try(each.value.maximum_execution_frequency, null)
  resource_id_scope           = try(each.value.resource_id_scope, null)
  resource_types_scope        = try(each.value.resource_types_scope, null)
  tag_key_scope               = try(each.value.tag_key_scope, null)
  tag_value_scope             = try(each.value.tag_value_scope, null)
}

resource "aws_config_organization_custom_policy_rule" "org_config" {
  for_each = {
    for item in try(var.settings.organization.custom_policy_rules, []) : item.name => item
    if var.is_hub
  }
  name                        = each.value.name
  description                 = try(each.value.description, null)
  policy_runtime              = try(each.value.policy_runtime, "guard-2.x.x")
  policy_text                 = each.value.policy_text
  trigger_types               = try(each.value.trigger_types, ["ConfigurationItemChangeNotification"])
  excluded_accounts           = try(each.value.excluded_accounts, null)
  input_parameters            = try(each.value.input_parameters, null)
  maximum_execution_frequency = try(each.value.maximum_execution_frequency, null)
  resource_id_scope           = try(each.value.resource_id_scope, null)
  resource_types_scope        = try(each.value.resource_types_scope, null)
  tag_key_scope               = try(each.value.tag_key_scope, null)
  tag_value_scope             = try(each.value.tag_value_scope, null)
}