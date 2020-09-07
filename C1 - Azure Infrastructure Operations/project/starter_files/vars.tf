variable "location" {
  description = "The Azure Region in which all resources in this exercise should be created"
  default = "East US"
}

variable "prefix" {
  description = "the prefix which should be used for all resources in this exercise"
  default = "udacity"
}

variable "tagging" {
  description = "tag for all resources of this exercise"
  default = "udacity-nd082-webserver"
}

variable "instance" {
  description = "Number of instances to be deployed, multiple of 2"
  default = 2
}

variable "username" {
  description = "administrator username"
  default = "admin"
}
