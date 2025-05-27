module "eks-automode-agones-eu" {
  source = "./eks-automode-agones"

  aws_account_id     = var.aws_account_id
  aws_default_region = "eu-central-1"
  k8s_version        = "1.31"
  location_suffix    = "eu"
  vpc_cidr           = "10.0.0.0/16"
}

module "eks-automode-agones-us" {
  source = "./eks-automode-agones"

  aws_account_id     = var.aws_account_id
  aws_default_region = "us-east-1"
  k8s_version        = "1.31"
  location_suffix    = "us"
  vpc_cidr           = "10.1.0.0/16"
}

module "eks-automode-agones-jp" {
  source = "./eks-automode-agones"

  aws_account_id     = var.aws_account_id
  aws_default_region = "ap-northeast-1"
  k8s_version        = "1.32"
  location_suffix    = "jp"
  vpc_cidr           = "10.2.0.0/16"
}
