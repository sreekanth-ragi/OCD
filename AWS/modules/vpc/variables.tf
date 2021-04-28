variable "cidr_block" {}
variable "env" {
	default = "DevOps"
}
variable pub_cidr_block {
	type = list(string)
}
variable pvt_cidr_block {
	type = list(string)
}
variable az_zones {}