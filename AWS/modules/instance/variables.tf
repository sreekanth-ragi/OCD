variable "ami_id" {}
variable "instance_type" {}
variable "hostname" {}
variable "env" {
	default = "DevOps"

}
variable key_name {
	default = ""
}
variable sg_id {
}
variable pub_net_id {
	default = ""
}
variable pvt_net_id {
	default = ""
}
variable is_public {
	default = "false"
}
variable instance_count {}
variable user_data {
	default = ""
}
