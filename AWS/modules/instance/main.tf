resource "tls_private_key" "pvt_key" {
  algorithm							= "RSA"
  rsa_bits							= 1024    # Create a "myKey.pem" to your computer

  provisioner "local-exec" {
    command = "echo '${tls_private_key.pvt_key.private_key_pem}' > ./pvt_key.pem"
  }
}

resource "aws_key_pair" "key_pair" {
  key_name   = "pvtKey"
  public_key = tls_private_key.pvt_key.public_key_openssh
}


resource "aws_instance" "instance" {
	count							= var.instance_count
	ami								= var.ami_id
	instance_type					= var.instance_type
	key_name						= aws_key_pair.key_pair.key_name
	vpc_security_group_ids			= var.sg_id
	subnet_id						= var.is_public ? element(var.pub_net_id, 0): element(var.pvt_net_id, 0)
	associate_public_ip_address		= var.is_public ? true : false
	//user_data						= data.template_cloudinit.user_data.rendered

	tags							= {
											Name		= var.hostname
											Biz			= var.env
										}
}