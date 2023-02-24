
# create the S3 bucket for the front end
resource "aws_s3_bucket" "frontend_bucket" {
    bucket = var.frontend_bucket_name
}

# resource "aws_s3_bucket_ownership_controls" "frontend_ownership" {
#     bucket = aws_s3_bucket.frontend_bucket.id
#     rule {
#         object_ownership = "BucketOwnerEnforced"
#     }
# }

# server-side encryption is the default starting Jan 2023
# resource "aws_s3_bucket_server_side_encryption_configuration" "frontend_bucket_crypt" {
#     bucket = aws_s3_bucket.frontend_bucket.id
#     rule {
#         apply_server_side_encryption_by_default {
#           sse_algorithm = "AES256"
#         }
#     }  
# }

# waayyy too open resource policy
resource "aws_s3_bucket_policy" "frontend_bucket_policy" {
    bucket = aws_s3_bucket.frontend_bucket.id
    policy = data.aws_iam_policy_document.allow_all.json
}

data "aws_iam_policy_document" "allow_all" {
    statement {
      principals {
        type = "AWS"
        identifiers = ["*"]
      }
      actions = [
        "s3:*"          # s3:* for poor security?
      ]
      resources = [
        aws_s3_bucket.frontend_bucket.arn,                  # security issue?
        "${aws_s3_bucket.frontend_bucket.arn}/*"
      ]
    }
}

# copy files to the front-end bucket
# need to set the content-type, as terraform will default to binary/octet-stream
locals {
    mime_types = jsondecode(file("${path.module}/mimetype.json"))
}

resource "aws_s3_object" "upload_index" {
    for_each = fileset("../front-end/dist/", "*")
    bucket = aws_s3_bucket.frontend_bucket.id
    key = each.key
    source = "../front-end/dist/${each.key}"
    acl = "public-read"
    content_type = lookup(local.mime_types, regex("\\.[^.]+$", each.key), null)
}

# setup the S3 bucket as a website
resource "aws_s3_bucket_website_configuration" "frontend_website_config" {
    bucket = aws_s3_bucket.frontend_bucket.id
    index_document {
      suffix = "index.html"
    }
}
