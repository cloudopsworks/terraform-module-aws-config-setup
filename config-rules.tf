##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

resource "aws_config_config_rule" "rules" {
  for_each = {
    for rule in try(var.settings.config_rules, []) : rule.name => rule
  }
  name                        = each.key
  description                 = try(each.value.description, null)
  input_parameters            = try(jsonencode(each.value.input_parameters), each.value.input_parameters_json, null)
  maximum_execution_frequency = try(each.value.maximum_execution_frequency, null)
  source {
    owner             = each.value.owner
    source_identifier = try(each.value.source_identifier, null)
    dynamic "source_detail" {
      for_each = length(try(each.value.source_details, {})) > 0 ? [1] : []
      content {
        event_source                = try(each.value.source_details.event_source, null)
        message_type                = try(each.value.source_details.message_type, null)
        maximum_execution_frequency = try(each.value.source_details.maximum_execution_frequency, null)
      }
    }
    dynamic "custom_policy_details" {
      for_each = length(try(each.value.custom_policy_details, {})) > 0 ? [1] : []
      content {
        enable_debug_log_delivery = try(each.value.custom_policy_details.enable_debug_log_delivery, null)
        policy_text               = each.value.custom_policy_details.policy_text
        policy_runtime            = each.value.custom_policy_details.policy_runtime
      }
    }
  }
  dynamic "evaluation_mode" {
    for_each = length(try(each.value.evaluation_mode, {})) > 0 ? [1] : []
    content {
      mode = each.value.evaluation_mode.mode
    }
  }
  dynamic "scope" {
    for_each = length(try(each.value.scope, {})) > 0 ? [1] : []
    content {
      compliance_resource_id    = try(each.value.scope.compliance_resource_id, null)
      compliance_resource_types = try(each.value.scope.compliance_resource_types, null)
      tag_key                   = try(each.value.scope.tag_key, null)
      tag_value                 = try(each.value.scope.tag_value, null)
    }
  }
  tags       = local.all_tags
  depends_on = [aws_config_configuration_recorder.this]
}