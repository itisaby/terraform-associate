variable "vpc_id" {
  type = string

}

variable "public_key" {
  type = string
}

variable "instance_type" {
  type = string

}
variable "server_name" {
  type = string

}

variable "workspace_iam_roles" {
  default = {
    "stage" = "arn:aws:iam::123456789012:role/terraform-stage"
    "production" = "arn:aws:iam::123456789012:role/terraform-production"
  }
}