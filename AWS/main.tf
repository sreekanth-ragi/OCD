module "vpc" {
	source					= "./modules/vpc"
//	region					= var.region
	env					= var.env
	cidr_block				= var.cidr_block
	pub_cidr_block				= var.pub_cidr_block
	pvt_cidr_block				= var.pvt_cidr_block
	az_zones				= var.az_zones
}

module "instance" {
	source					= "./modules/instance"
	instance_count				= var.instance_count
	ami_id					= var.ami_id
	instance_type				= var.instance_type
	//key_name				= var.key_name
	pvt_net_id				= module.vpc.pvt_net_id
	pub_net_id				= module.vpc.pub_net_id
	sg_id					= module.vpc.sg_id
	is_public				= true
	hostname				= "devops-test-instance"
}
