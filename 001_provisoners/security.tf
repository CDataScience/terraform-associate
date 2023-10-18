resource "aws_security_group" "sg_my_server" {
  name        = "sg_my_server"
  description = "MyServer Security Group"
  vpc_id      =  data.aws_vpc.main #aws_vpc.main.id

  ingress = [ 
    {
        description      = "HTTP"
        from_port        = 80
        to_port          = 80
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/32"]
        ipv6_cidr_blocks = []
    },
    {
        description      = "SSH"
        from_port        = 22
        to_port          = 22
        protocol         = "tcp"
        cidr_blocks      = ["MY IP/32"]
        ipv6_cidr_blocks = []
    }
  ]
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

data "aws_vpc" "main" {
  id = "GRAB DEFAULT VPC FROM AWS" #var.vpc_id
}