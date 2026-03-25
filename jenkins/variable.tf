variable "cidr_block" {
  description = "This cidr use in jenkis-vpc"
  type        = string
}

variable "public_subnet" {
  description = "list of azs"
  type        = list(string)
}

variable "instance_type" {
  description = "jenkins server instance type"
  type        = string
}

