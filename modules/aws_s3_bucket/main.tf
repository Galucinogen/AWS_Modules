######
# S3 #
######

resource "aws_s3_bucket" "bucket" {
  count  = "${var.create_s3_bucket ? var.create_s3_bucket : 0 }"
  bucket = "${element(var.bucket_name, count.index)}"
  acl    = "${var.acl_name}"

  versioning {
    enabled = "${var.enable_versioning}"
  }
}
