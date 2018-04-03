variable "create_s3_bucket" {
  description = "The trigger for creating S3 bucket"
}

variable "bucket_name" {
  description = "The Bucket name"
  type        = "list"
}

variable "acl_name" {
  description = "The S# ACL name"
}

variable "enable_versioning" {
  description = "The enable bucket versioning"
}

#variable "" {
#  description = "The "
#}

