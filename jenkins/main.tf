#VPC
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs                  = data.aws_availability_zones.my_azs.names
  enable_dns_hostnames = true

  public_subnets = var.public_subnet
  public_subnet_tags = {
    Name        = "Public-Subnet"
    Environment = "dev"
    Terraform   = "true"
  }
  public_route_table_tags = {
    Name        = "Jenkins-Public-Route-Table"
    Environment = "dev"
    Terraform   = "true"
  }
  tags = {
    Terraform   = "true"
    Environment = "dev"
    Name        = "Jenkins-VPC"
  }
}

#SG
module "jenkins_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "jenkins-sg"
  description = "Security group for jenkins with custom ports open within VPC"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      description = "Allow Jenkins Web UI"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "Allow SSH access"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_with_cidr_blocks = [

    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "Allow all outbound traffic"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  tags = {
    Terraform   = "true"
    Environment = "dev"
    Name        = "Jenkins-SG"
  }
}

#EC2
module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "jenkins-server"

  instance_type               = var.instance_type
  ami                         = data.aws_ami.my_ami.id
  key_name                    = "eks-tf-key"
  monitoring                  = false
  subnet_id                   = module.vpc.public_subnets[0]
  vpc_security_group_ids      = [module.jenkins_sg.security_group_id]
  associate_public_ip_address = true
  user_data                   = file("software-installation.sh")
  tags = {
    Name        = "Jenkins-EC2-Instance"
    Terraform   = "true"
    Environment = "dev"
  }
}