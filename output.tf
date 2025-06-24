##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

output "config_bucket_name" {
  value = var.is_hub ? module.config_bucket[0].s3_bucket_id : null
}

output "config_bucket_arn" {
  value = var.is_hub ? module.config_bucket[0].s3_bucket_arn : null
}

output "config_kms_key_arn" {
  value = var.is_hub ? aws_kms_key.config[0].arn : null
}

output "config_kms_key_id" {
  value = var.is_hub ? aws_kms_key.config[0].key_id : null
}

output "config_kms_alias" {
  value = var.is_hub ? aws_kms_alias.config[0].name : null
}

output "config_sns_topic_name" {
  value = var.is_hub || try(var.settings.create_recorder, false) ? aws_sns_topic.config_sns[0].name : null
}

output "config_sns_topic_arn" {
  value = var.is_hub || try(var.settings.create_recorder, false) ? aws_sns_topic.config_sns[0].arn : null
}

output "config_service_linked_role_arn" {
  value = var.is_hub ? aws_iam_service_linked_role.config[0].arn : null
}

output "config_iam_role_arn" {
  value = var.is_hub ? aws_iam_role.this[0].arn : null
}