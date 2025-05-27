variable "project_unique_id" {}

variable "allowed_ipaddr_list" {
  type    = list(string)
  default = ["127.0.0.1/8"]
}

variable "base_dnsdomain" {
  default = "sb-cfg-9a2d.sandb0x.site"
}

# <AWS>
variable "aws_account_id" {
  default = "000000000000"
}
variable "aws_default_region" {
  default = "us-east-1"
}
variable "aws_access_key" {
  default = "AKXXXXXXXX"
}
variable "aws_secret_key" {
  default = "AWxxxxxxxx00000000"
}
# </AWS>

# <Azure>
variable "azure_default_location" {
  default = "centralus"
}
# </Azure>

# <Google>
variable "gcp_default_region" {
  default = "us-central1"
}
variable "gcp_project_id" {
  default = "my-proj-b78e"
}
# </Google>
