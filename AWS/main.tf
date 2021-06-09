module "vpc" {
	source				= "./modules/vpc"
//	region				= var.region
	env				= var.env
	cidr_block			= var.cidr_block
	pub_cidr_block			= var.pub_cidr_block
	pvt_cidr_block			= var.pvt_cidr_block
	az_zones			= var.az_zones
}

data "template_file" "bastion_data" {
  template = file("./user-data/bastion.yaml")
}

resource "aws_key_pair" "auth_key" {
  	key_name			= "auth_key"
  	public_key			= "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAgQDUKw4wEitSzOuhfdFh6KyjHu+4bsYrBPnerIGc6J7VVfildeSqHFsNbdo/6hIKp5t33kzYZy9Wi4/F5DVYhfXqTRZuhqg8+YX5oXoD6DEjHwGavPt1s3/jRxM5HvduqlgmWhdy1FaCLAkdc7YbgiR5uoS0c+tbqy8+BnBQzoFRMw=="
}



module "bastion" {
	source				= "./modules/instance"
	instance_count			= var.instance_count
	ami_id				= var.ami_id
	key_name			= aws_key_pair.auth_key.key_name
	instance_type			= var.instance_type
	pvt_net_id			= module.vpc.pvt_net_id
	pub_net_id			= module.vpc.pub_net_id
	sg_id				= module.vpc.sg_id
	is_public			= true
	hostname			= "bastion-host"
	user_data			= data.template_file.bastion_data.rendered
}

data "template_file" "master_data" {
  	template 			= file("./user-data/master.yaml")
}

module "master" {
	source				= "./modules/instance"
	instance_count			= var.instance_count
	ami_id				= var.ami_id
	instance_type			= var.instance_type
	key_name			= aws_key_pair.auth_key.key_name
	pvt_net_id			= module.vpc.pvt_net_id
	sg_id				= module.vpc.sg_id
	is_public			= false
	hostname			= "k8s-master"
	user_data			= data.template_file.master_data.rendered
}

data "template_file" "node_data" {
  	template 			= file("./user-data/node.yaml")
}


module "node" {
	source				= "./modules/instance"
	instance_count			= var.instance_count
	ami_id				= var.ami_id
	instance_type			= var.instance_type
	key_name			= aws_key_pair.auth_key.key_name
	pvt_net_id			= module.vpc.pvt_net_id
	sg_id				= module.vpc.sg_id
	is_public			= false
	hostname			= "k8s-node"
	user_data			= data.template_file.node_data.rendered
}

