## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.83 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.5 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.95.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_config_bucket"></a> [config\_bucket](#module\_config\_bucket) | terraform-aws-modules/s3-bucket/aws | ~> 4.1 |
| <a name="module_tags"></a> [tags](#module\_tags) | cloudopsworks/tags/local | 1.0.9 |

## Resources

| Name | Type |
|------|------|
| [aws_config_config_rule.rules](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_config_rule) | resource |
| [aws_config_configuration_aggregator.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_configuration_aggregator) | resource |
| [aws_config_configuration_recorder.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_configuration_recorder) | resource |
| [aws_config_configuration_recorder_status.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_configuration_recorder_status) | resource |
| [aws_config_delivery_channel.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_delivery_channel) | resource |
| [aws_config_organization_conformance_pack.org_config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_organization_conformance_pack) | resource |
| [aws_config_organization_custom_policy_rule.org_config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_organization_custom_policy_rule) | resource |
| [aws_config_organization_custom_rule.org_config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_organization_custom_rule) | resource |
| [aws_config_organization_managed_rule.org_config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_organization_managed_rule) | resource |
| [aws_config_retention_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_retention_configuration) | resource |
| [aws_iam_policy.config_kms_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.config_s3_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.config_sns_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.config_aggregator](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.config_aggregator](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.config_kms_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.config_s3_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.config_sns_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_service_linked_role.config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_service_linked_role) | resource |
| [aws_kms_alias.config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_alias.config_replica](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_key_policy.config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key_policy) | resource |
| [aws_kms_key_policy.config_replica](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key_policy) | resource |
| [aws_kms_replica_key.config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_replica_key) | resource |
| [aws_organizations_delegated_administrator.multiaccount](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_delegated_administrator) | resource |
| [aws_organizations_delegated_administrator.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_delegated_administrator) | resource |
| [aws_sns_topic.config_sns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_policy.config_sns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_policy) | resource |
| [random_string.random](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.config_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.config_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.config_kms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.config_kms_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.config_s3_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.config_sns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.config_sns_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_kms_alias.config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/kms_alias) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_extra_tags"></a> [extra\_tags](#input\_extra\_tags) | Extra tags to add to the resources | `map(string)` | `{}` | no |
| <a name="input_is_hub"></a> [is\_hub](#input\_is\_hub) | Is this a hub or spoke configuration? | `bool` | `false` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Prefix for the bucket name | `string` | `"config"` | no |
| <a name="input_org"></a> [org](#input\_org) | Organization details | <pre>object({<br/>    organization_name = string<br/>    organization_unit = string<br/>    environment_type  = string<br/>    environment_name  = string<br/>  })</pre> | n/a | yes |
| <a name="input_random_bucket_suffix"></a> [random\_bucket\_suffix](#input\_random\_bucket\_suffix) | Random suffix to append to the bucket name | `bool` | `true` | no |
| <a name="input_settings"></a> [settings](#input\_settings) | Settings for the configuration recorder | `any` | `{}` | no |
| <a name="input_short_system_name"></a> [short\_system\_name](#input\_short\_system\_name) | Use short system name for bucket name | `bool` | `false` | no |
| <a name="input_spoke_def"></a> [spoke\_def](#input\_spoke\_def) | Spoke ID Number, must be a 3 digit number | `string` | `"001"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_config_bucket_arn"></a> [config\_bucket\_arn](#output\_config\_bucket\_arn) | n/a |
| <a name="output_config_bucket_name"></a> [config\_bucket\_name](#output\_config\_bucket\_name) | n/a |
| <a name="output_config_iam_role_arn"></a> [config\_iam\_role\_arn](#output\_config\_iam\_role\_arn) | n/a |
| <a name="output_config_kms_alias"></a> [config\_kms\_alias](#output\_config\_kms\_alias) | n/a |
| <a name="output_config_kms_key_arn"></a> [config\_kms\_key\_arn](#output\_config\_kms\_key\_arn) | n/a |
| <a name="output_config_kms_key_id"></a> [config\_kms\_key\_id](#output\_config\_kms\_key\_id) | n/a |
| <a name="output_config_service_linked_role_arn"></a> [config\_service\_linked\_role\_arn](#output\_config\_service\_linked\_role\_arn) | n/a |
| <a name="output_config_sns_topic_arn"></a> [config\_sns\_topic\_arn](#output\_config\_sns\_topic\_arn) | n/a |
| <a name="output_config_sns_topic_name"></a> [config\_sns\_topic\_name](#output\_config\_sns\_topic\_name) | n/a |
