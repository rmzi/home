provider "aws" {
  region     = "${var.aws["region"]}"
  access_key = "${var.aws["access_key"]}"
  secret_key = "${var.aws["secret_key"]}"
}
