# Route53 Domain name and resource records
data "aws_route53_zone" "zone" {
  name         = "${var.dns["zone"]}"
  private_zone = false
}

# resource "aws_route53_record" "site_cname" {
#   zone_id = "${data.aws_route53_zone.zone.zone_id}"
#   name    = "${var.dns["name"]}"
#   type    = "NS"
#   ttl     = "30"
#
#   # records = "${split(",",data.aws_route53_zone.zone.name_servers)}"
#   records = [
#     "${data.aws_route53_zone.zone.name_servers[0]}",
#     "${data.aws_route53_zone.zone.name_servers[1]}",
#     "${data.aws_route53_zone.zone.name_servers[2]}",
#     "${data.aws_route53_zone.zone.name_servers[3]}",
#   ]
# }

resource "aws_route53_record" "site_cname" {
  zone_id = "${data.aws_route53_zone.zone.zone_id}"
  name    = "${var.dns["name"]}"
  type    = "CNAME"
  ttl     = "300"

  # records = ["${aws_cloudfront_distribution.site.domain_name}"]
  records = ["${aws_s3_bucket.site.website_endpoint}"]
}
