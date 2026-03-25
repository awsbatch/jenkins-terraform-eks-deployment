variable "cidr_block" {
  description = "This cidr use in Eks cluster"
  type        = string
}

variable "public_subnet" {
  description = "list of azs"
  type        = list(string)
}

variable "private_subnet" {
  description = "this is for private subnet for eks cluster"
  type        = list(string)
}
