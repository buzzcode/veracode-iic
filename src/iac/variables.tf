variable "aws_region" {
    type = string
    default = "us-west-1"
}

variable "aws_availability_zone" {
    type = string
    default = "us-west-1b"
}

variable "vpc_cidr" {
    type = string
    default = "10.0.0.0/16"
}

variable "subnet_cidr" {
    type = string
    default = "10.0.0.0/24"
}

variable "aws_profile" {
    type = string
    # from .auto.tfvars
}

variable "frontend_bucket_name" {
    type = string
}

variable "backend_service_name" {
    type = string
}

variable "backend_image_name" {
    type = string
    # from .auto.tfvars
}