
# create the VPC
# resource "aws_vpc" "IIC_vpc" {
#     cidr_block  = var.vpc_cidr
# }

# create the S3 bucket for the front end
resource "aws_s3_bucket" "frontend_bucket" {
    bucket = var.frontend_bucket_name

    // acl ??
}

# server-side encryption is required starting Jan 2023
resource "aws_s3_bucket_server_side_encryption_configuration" "frontend_bucket_crypt" {
    bucket = aws_s3_bucket.frontend_bucket.id
    rule {
        apply_server_side_encryption_by_default {
          sse_algorithm = "AES256"
        }
    }  
}

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
        "s3:GetObject"          # s3:* for poor security?
      ]
      resources = [
        aws_s3_bucket.frontend_bucket.arn,                  # security issue?
        "${aws_s3_bucket.frontend_bucket.arn}/*"
      ]
    }
}

# copy files to the front-end bucket
# resource "aws_s3_object" "upload_frontend" {
#     for_each = fileset("../front-end/dist/", "*")
#     bucket = aws_s3_bucket.frontend_bucket.id
#     key = each.value
#     source = "../front-end/dist/${each.value}"
#     #server_side_encryption = "AES256"
#      depends_on = [
#        aws_s3_bucket_server_side_encryption_configuration.frontend_bucket_crypt
#     ]
# }

resource "aws_s3_bucket_website_configuration" "frontend_website_config" {
    bucket = aws_s3_bucket.frontend_bucket.id
    index_document {
      suffix = "index.html"
    }
}
