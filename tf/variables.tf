variable "aws" {
  description = "(Required) AWS Credentials"
  type        = "map"

  default = {
    region     = "us-east-1"
    account_id = ""
    access_key = ""
    secret_key = ""
  }
}

variable "dns" {
  description = "(Required) FQDN for your website"
  type        = "map"

  default = {
    name = ""
    zone = ""
  }
}
