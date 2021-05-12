/*==== VPC's Default Security Group ======*/
resource "aws_security_group" "default" {
  name              = "${var.env}-default-sg"
  description       = "Default security group to allow inbound/outbound from the VPC"
  vpc_id            = aws_vpc.vpc.id
  depends_on        = [aws_vpc.vpc]
  ingress {
    from_port       = "0"
    to_port         = "0"
    protocol        = "-1"
    self            = true
  }
  ingress {
    from_port       = "22"
    to_port         = "22"
    protocol        = "tcp"
    cidr_blocks     = ["124.123.173.161/32"]
  }
  ingress {
    from_port       = "0"
    to_port         = "0"
    protocol        = "-1"
    cidr_blocks     = [var.cidr_block]
  }
  egress {
    from_port       = "0"
    to_port         = "0"
    protocol        = "-1"
    self            = "true"
  }
  egress {
    from_port       = "0"
    to_port         = "0"
    protocol        = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
    Name        = "${var.env}-SG"
    Environment = var.env
  }
}