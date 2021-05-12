variable "region" {
	default = "ap-south-1"
}
variable "access_key" {}
variable "secret_key" {}
variable "cidr_block" {
	default = "10.0.0.0/16"
}
variable "env" {
	default = "DevOps-TF"
}
variable "pub_cidr_block" {
	default = ["10.0.0.0/24"]
}
variable "pvt_cidr_block" {
	default = ["10.0.1.0/24"]
}
variable "az_zones" {
	default = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
}
variable "ami_id" {
	default =	"ami-01c76ebfe68e7fc45"
}
variable "instance_type" {
	default = "t2.micro"
}
variable "instance_count" {
	default = 1

}
//variable "key_name" {}
