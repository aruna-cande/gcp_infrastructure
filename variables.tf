
variable "project" {
  type = string
}

variable "region" {
  type    = string
  default = "us-east1"
}

variable "machine_type" {
  type = string
}

variable "app_subnet" {
  type = string
  default = "10.1.0.0/20"
}

variable "vpc_name" {
  type = string
}

variable "db_instance_type" {
  type = string
}

variable "postgres_dbname" {
  type = string
}