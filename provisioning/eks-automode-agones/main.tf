provider "aws" {
  region = local.region
}

data "aws_availability_zones" "available" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

locals {
  name            = "eks-auto-agones-${var.location_suffix}"
  cluster_version = var.k8s_version
  region          = var.aws_default_region

  vpc_cidr = var.vpc_cidr
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  tags = {
    Test = local.name
  }
}

resource "aws_eks_access_entry" "for-root" {
  cluster_name  = local.name
  principal_arn = "arn:aws:iam::${var.aws_account_id}:root"
  type          = "STANDARD"

  depends_on = [
    module.aws-eks-automode-using-module,
    module.disabled_aws-eks-automode-using-module,
    module.vpc,
  ]
}

resource "aws_eks_access_policy_association" "for-root" {
  cluster_name  = local.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = "arn:aws:iam::${var.aws_account_id}:root"

  access_scope {
    type = "cluster"
  }

  depends_on = [
    module.aws-eks-automode-using-module,
    module.disabled_aws-eks-automode-using-module,
    module.vpc,
  ]
}

################################################################################
# EKS Module
################################################################################

module "aws-eks-automode-using-module" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.31"

  cluster_name                   = local.name
  cluster_version                = local.cluster_version
  cluster_endpoint_public_access = true

  enable_cluster_creator_admin_permissions = true

  cluster_compute_config = {
    enabled    = true
    node_pools = ["general-purpose"]
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  tags = local.tags
}

module "disabled_aws-eks-automode-using-module" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.31"

  create = false
}

################################################################################
# Supporting Resources
################################################################################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = local.name
  cidr = local.vpc_cidr

  azs             = local.azs
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 48)]
  intra_subnets   = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 52)]

  enable_nat_gateway = true
  single_nat_gateway = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }

  tags = local.tags
}
