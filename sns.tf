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