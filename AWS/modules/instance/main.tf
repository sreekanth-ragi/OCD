

resource "aws_instance" "instance" {
	count							= var.instance_count
	ami								= var.ami_id
	instance_type					= var.instance_type
	key_name						= var.key_name
	vpc_security_group_ids			= var.sg_id
	subnet_id						= var.is_public ? element(var.pub_net_id, 0): element(var.pvt_net_id, 0)
	associate_public_ip_address		= var.is_public ? true : false
	user_data						= var.user_data
	tags							= {
											Name		= var.hostname
											Biz			= var.env
										}
}