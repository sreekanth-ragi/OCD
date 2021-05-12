variable "ami_id" {}
variable "instance_type" {}
variable "hostname" {}
variable "env" {
		default = "DevOps"

}
//variable key_name {}
variable sg_id {
}
variable pub_net_id {
}
variable pvt_net_id {
}
variable is_public {
		default = "false"
}
variable instance_count {}