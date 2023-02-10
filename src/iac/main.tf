
# create the VPC
# resource "aws_vpc" "IIC_vpc" {
#     cidr_block  = var.vpc_cidr
# }

# create the S3 bucket for the front end
resource "aws_s3_bucket" "frontend_bucket" {
    bucket = var.frontend_bucket_name

    // acl
    // policy ??
    // website {}
}

# copy files to the front-end bucket
resource "aws_s3_object" "upload_frontend" {
    for_each = fileset("../front-end/dist/", "*")
    bucket = aws_s3_bucket.frontend_bucket.id
    key = each.value
    source = "../front-end/dist/${each.value}"
}
