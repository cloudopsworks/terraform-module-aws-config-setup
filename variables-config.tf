##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
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

variable "settings" {
  description = "Settings for the configuration recorder"
  type        = any
  default     = {}
}