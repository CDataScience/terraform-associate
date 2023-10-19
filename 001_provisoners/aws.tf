resource "aws_instance" "my_server" {
  ami                    = "ami-041feb57c611358bd"
  instance_type          = "t2.micro"
  key_name = aws_key_pair.deployer.key_name 
  vpc_security_group_ids = [aws_security_group.sg_my_server.id]
  user_data = data.template_file.user_data.rendered
  provisioner "file" {
    content     = "come on"
    destination = "/home/ec2-user/data.txt"
    connection {
      type     = "ssh"
      user     = "ec2-user"
      password = "${file("~/.ssh/terraform")}"
      host     = self.public_ip
    }
  }
  provisioner "local-exec" {
    command = "echo ${self.private_ip} >> private_ip.txt"
  }

  provisioner "remote-exec" {
    inline = [
      "puppet apply",
      "consul join ${aws_instance.my_server.private_ip}",
    ]

    connection {
      type     = "ssh"
      user     = "ec2-user"
      password = "${file("~/.ssh/terraform")}"
      host     = self.public_ip
    }
  }

  tags = {
   Name = "MyServer"
  }
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  
  providers = {
    aws = aws.us
  }
  
  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCVvCiokVv8Q+K3NbjiHjI1Q46TQ8SDBxeI+d7209FeVow27OiwdrSPjXomsROY/Hw08lwILygNrpWYZ9XqVHDoTGaPmPdETxQb3JLxKG4ZNXgqrevRFQoQIcTBjotdHo4oxx2uzr+lQUFPl//pmPx8akCz97cRxdFNkNvxmhu2sl2dbMgaYKoau811Jvitq4oW4wMh+eI/gTW+ZsvS+3y9bMT+ObnozlxpNezShHcCNpY6mNXyxEW8UacCZ6sCcTBfkCsc4/gBt+r0h3yQ2qlNR+CwXCu0oozjMl9QwzjNNyg78xGeisl4QV0UnPbF1OFoXEhwGppeEObrJ6Oats6uO1Wx+EvU814jW1tk3AThay4G7eQNrwsDGpnBD3D/EaCT3aHnQ/JNFePCV6FtyQYRaVl5Jl55/bgVGy5pMF90EJoKYl6brqYwT8vK7duiPEtQY4d7PlObeOASsJ3LR3oCEIE4vJSQZAem8+wT9mIOsTEmncMRW3UytxtwD/qpzmM= keiso@keiso"
}