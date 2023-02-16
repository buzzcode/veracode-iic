variable "vpc_cidr" {
    type = string
    default = "10.0.0.0/16"
}

variable "frontend_bucket_name" {
    type = string
}

variable "backend_service_name" {
    type = string
}