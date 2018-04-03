#######
# AWS #
# SES #
#######
resource "aws_ses_domain_identity" "domain" {
  count  = "${var.create_ses ? 1 : 0}"
  domain = "${var.domain}"
}

resource "aws_ses_domain_dkim" "amazonses_dkim_records" {
  count  = "${var.create_ses && var.create_dkim ? 1 : 0}"
  domain = "${aws_ses_domain_identity.domain.domain}"
}
