##
# (c) 2021-2025
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

variable "name_prefix" {
  description = "Prefix for the bucket name"
  type        = string
  default     = "config"
}

variable "random_bucket_suffix" {
  description = "Random suffix to append to the bucket name"
  type        = bool
  default     = true
}

variable "short_system_name" {
  description = "Use short system name for bucket name"
  type        = bool
  default     = false
}

## Settings for AWS Config, YAML format
#settings:
#  create_recorder: true | false # Create configuration recorder (default: false), if is_hub is true, this will be ignored and will create recorder
#  recorder_enabled: true | false # Enable configuration recorder (default: true)
#  retention_period_in_days: 365 # (optional) Retention period for AWS Config data in days (default: 365)
#  delivery_frequency: One_Hour | Three_Hours | Six_Hours | Twelve_Hours | TwentyFour_Hours # (optional) Delivery frequency for AWS Config data (default: "TwentyFour_Hours")
#  custom: true | false # Use custom name for configuration recorder and delivery channel (default: false)
#  service_role: true | false # Use service role for AWS Config (default: false)
#  service_role_arn: "arn:aws:iam::123456789012:role/aws-service-role/config.amazonaws.com/AWSServiceRoleForConfig" # (required if service_role is false)
#  s3_bucket_name: "my-config-bucket" # (required if is_hub is false)
#  s3_prefix: "config" # (optional) S3 prefix for AWS Config bucket (default: "")
#  recording:
#    all_supported: true | false # Record all supported resource types (default: true)
#    resource_types: # (optional) List of resource types to record (default: [])
#      - "AWS::EC2::Instance" # Example resource type
#      - "AWS::S3::Bucket" # Another resource type
#    include_global_resource_types: true | false # Include global resource types (default: null)
#    exclusion_by_resource_types: # (optional) List of resource types to exclude from recording (default: [])
#      - "AWS::IAM::User" # Example resource type to exclude
#      - "AWS::Lambda::Function" # Another resource type to exclude
#    use_only: "ALL_SUPPORTED_RESOURCE_TYPES" | "INCLUSION_BY_RESOURCE_TYPES" | "EXCLUSION_BY_RESOURCE_TYPES" # (optional) Use only specific recording strategy (default: null)
#    recording_frequency: "CONTINUOUS" | "DAILY" # (optional) Recording frequency (default: "CONTINUOUS")
#    override: # (optional) Recording mode override settings
#      description: "Override recording mode for specific resource types" # (optional) Description for override
#      resource_types: # (required) List of resource types for override
#        - "AWS::EC2::Instance" # Example resource type for override
#        - "AWS::S3::Bucket" # Another resource type for override
#      recording_frequency: "CONTINUOUS" | "DAILY" # (optional) Recording frequency for override (default: "CONTINUOUS")
#  aggregators: # (optional) List of aggregators for AWS Config (default: [])
#    - name: "my-aggregator" # Name of the aggregator
#      account:
#        account_ids: # (required) List of account IDs to aggregate from
#          - "123456789012" # Example account ID
#          - "47654321098" # Another account ID
#        all_regions: true | false # (optional) Aggregate from all regions (default: false)
#        regions: # (required) List of regions to aggregate from
#          - "us-east-1" # Example region
#          - "us-west-2" # Another region
#     organization: # (optional) Organization settings for aggregator
#       all_regions: true | false # (optional) Aggregate from all regions in the organization (default: false)
#        regions: # (required) List of regions to aggregate from
#          - "us-east-1" # Example region
#          - "us-west-2" # Another region
#  organization:
#    delegated: true | false
#    multiaccount_delegated: true | false
#    account_id: "123456789012" # (required if delegated or multiaccount_delegated is true)
#    conformance_packs:
#     - name: "my-conformance-pack" # Name of the conformance pack
#       template_body: "BODY" # (required) Path to the conformance pack template
#       template_s3_uri: "s3://my-bucket/conformance-pack-template.yaml" # (optional) S3 URI for the conformance pack template
#       delivery_s3_bucket: "my-conformance-pack-bucket" # (optional) S3 bucket for conformance pack delivery
#       delivery_s3_key_prefix: "conformance-packs" # (optional) S3 key prefix for conformance pack delivery
#       excluded_accounts: # (optional) List of accounts to exclude from the conformance pack
#         - "123456789012" # Example account ID to exclude
#       input_parameters: # (optional) Input parameters for the conformance pack
#         - name: "ParameterName" # Name of the input parameter
#           value: "ParameterValue" # Value of the input parameter
#     managed_rules: # (optional) List of managed rules for the conformance pack (default: [])
#       - name: "S3BucketPublicReadProhibited" # Example managed rule
#         description: "Ensure S3 buckets do not allow public read access" # (optional) Description of the managed rule
#         input_parameters: <JSON> # (optional) Input parameters for the managed rule
#         maximum_execution_frequency: "One_Hour" | "Three_Hours" | "Six_Hours" | "Twelve_Hours" | "TwentyFour_Hours" # (optional) Maximum execution frequency for the managed rule (default: "TwentyFour_Hours")
#         excluded_accounts: # (optional) List of accounts to exclude from the managed rule
#         rule_identifier: "S3_BUCKET_PUBLIC_READ_PROHIBITED" # (required) Identifier for the managed rule
#         resource_id_scope: "arn:aws:s3:::my-bucket" # (optional) Resource ID scope for the managed rule
#         resource_types_scope: # (optional) List of resource types to scope the managed rule
#         tag_key_scope: "Environment" # (optional) Tag key scope for the managed rule
#         tag_value_scope: "Production" # (optional) Tag value scope for the managed rule
#     custom_rules: # (optional) List of custom rules for the conformance pack (default: [])
#       - name: "MyCustomRule" # Name of the custom rule
#         description: "Custom rule to check S3 bucket encryption" # (optional) Description of the custom rule
#         lambda_function_arn: "arn:aws:lambda:us-east-1:123456789012:function:MyCustomRuleFunction" # (required) ARN of the Lambda function for the custom rule
#         trigger_types: # (optional) List of trigger types for the custom rule (default: ["ConfigurationItemChangeNotification"])
#         input_parameters: <JSON> # (optional) Input parameters for the custom rule
#         maximum_execution_frequency: "One_Hour" | "Three_Hours" | "Six_Hours" | "Twelve_Hours" | "TwentyFour_Hours" # (optional) Maximum execution frequency for the custom rule (default: "TwentyFour_Hours")
#         excluded_accounts: # (optional) List of accounts to exclude from the managed rule
#         resource_id_scope: "arn:aws:s3:::my-bucket" # (optional) Resource ID scope for the managed rule
#         resource_types_scope: # (optional) List of resource types to scope the managed rule
#         tag_key_scope: "Environment" # (optional) Tag key scope for the managed rule
#         tag_value_scope: "Production" # (optional) Tag value scope for the managed rule
#     custom_policy_rules: # (optional) List of custom policy rules for the conformance pack (default: [])
#       - name: "MyCustomPolicyRule" # Name of the custom policy rule
#         description: "Custom policy rule to check S3 bucket encryption" # (optional) Description of the custom policy rule
#         policy_text: "POLICY" # (required) Path to the custom policy rule JSON file
#         policy_runtime: "guard-2.x.x" # (optional) Runtime for the custom policy rule (default: "guard-2.x.x")
#         trigger_types: # (optional) List of trigger types for the custom rule (default: ["ConfigurationItemChangeNotification"])
#         input_parameters: <JSON> # (optional) Input parameters for the custom rule
#         maximum_execution_frequency: "One_Hour" | "Three_Hours" | "Six_Hours" | "Twelve_Hours" | "TwentyFour_Hours" # (optional) Maximum execution frequency for the custom rule (default: "TwentyFour_Hours")
#         excluded_accounts: # (optional) List of accounts to exclude from the managed rule
#         resource_id_scope: "arn:aws:s3:::my-bucket" # (optional) Resource ID scope for the managed rule
#         resource_types_scope: # (optional) List of resource types to scope the managed rule
#         tag_key_scope: "Environment" # (optional) Tag key scope for the managed rule
#         tag_value_scope: "Production" # (optional) Tag value scope for the managed rule
#  kms: # (optional) KMS settings for encryption, will be created automatically if is_hub is true
#    deletion_window: 15 # (optional) KMS deletion window in days (default: 15)
#    rotation_period: 90 # (optional) KMS rotation period in days (default: 90)
#    multi_region: true | false # (optional) Create multi-region KMS key (default: false)
#    # Optionals to reference existing KMS key (when is_hub = false)
#    alias: "alias/aws/config" # (optional) KMS alias for encryption (default: null)
#    kms_key_arn: "arn:aws:kms:us-east-1:123456789012:key/abcd1234-a123-456a-a12b-a123b4cd56ef" # (optional) KMS key ARN for encryption (default: null)
#  additional_accounts_access: # (optional) List of additional accounts to grant access to the configuration recorder (default: [])
#    - "123456789012" # Account ID
#    - "47654321098" # Another Account ID
#  additional_kms_admins: # (optional) List of additional KMS administrators (default: []) active when multi_region is true
#    - "arn:aws:iam::123456789012:root" # Account root
#    - "arn:aws:iam::47654321098:root" # Another Account root
#  additional_services:
#    - "config.us-east-1.amazonaws.com" # Additional service to allow KMS access (default: [])
#    - "config.us-west-2.amazonaws.com" # Another service
#
variable "settings" {
  description = "Settings for the configuration recorder"
  type        = any
  default     = {}
}