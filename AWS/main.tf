module "vpc" {
	source					= "./modules/vpc"
//	region					= var.region
	env						= var.env
	cidr_block				= var.cidr_block
	pub_cidr_block			= var.pub_cidr_block
	pvt_cidr_block			= var.pvt_cidr_block
	az_zones				= var.az_zones
}

