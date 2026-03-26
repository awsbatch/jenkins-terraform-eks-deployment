#VPC
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = var.cidr_block

  azs                  = data.aws_availability_zones.my_azs.names
  enable_dns_hostnames = true
  private_subnets      = var.private_subnet

  public_subnets     = var.public_subnet
  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    "kubernetes.io/cluster/my_eks_cluster" = "shared"
  }
  public_subnet_tags = {
    "kubernetes.io/role/elb"               = "1"
    "kubernetes.io/cluster/my_eks_cluster" = "shared"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb"      = "1"
    "kubernetes.io/cluster/my_eks_cluster" = "shared"
  }
}

#EKS Cluster Module
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = "my-cluster"
  kubernetes_version = "1.33"


  # Optional
  endpoint_public_access = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # EKS Managed Node Group(s)
  eks_managed_node_groups = {
    my_node_group = {
      instance_types = ["t3.medium"]
      min_size       = 2
      max_size       = 3
      desired_size   = 2
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

