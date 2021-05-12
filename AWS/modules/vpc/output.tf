output "vpc_id" {
	value = aws_vpc.vpc.id
}
output "sg_id"  {
	value = aws_security_group.default.*.id
}
output "pub_net_id" {
	value = aws_subnet.pub_net.*.id
}
output "pvt_net_id" {
	value = aws_subnet.pvt_net.*.id
}