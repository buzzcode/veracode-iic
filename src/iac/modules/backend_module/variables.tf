
variable "backend_service_name" {
    type = string
}

variable "backend_image_name" {
    type = string
}

variable "ingress_sg" {
    type = string
}

variable "egress_sg" {
    type = string
}

variable "subnet" {
    type = string
}