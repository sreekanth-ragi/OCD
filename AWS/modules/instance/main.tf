resource "aws_instance" instance {
	count				= var.count
	ami					= var.ami_id
	instance_type		= var.instance_type
	key_name			= var.key_name
	security_groups		= var.sg_id
	subnet_id			= var.is_public = false ? var.pvt.net.id : var.pub_net_id

	tags				= {
							Name		= var.hostname
							Biz			= var.env
						}




}