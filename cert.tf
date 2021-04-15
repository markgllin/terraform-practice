# The below is an adapted example from Terraform documentation
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate
resource "tls_private_key" "pkey" {
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "cert" {
  key_algorithm   = "RSA"
  private_key_pem = tls_private_key.pkey.private_key_pem

  subject {
    common_name  = "marklin.com"
    organization = "Mark Lin Inc."
  }

  validity_period_hours = 168

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "aws_acm_certificate" "cert" {
  private_key      = tls_private_key.pkey.private_key_pem
  certificate_body = tls_self_signed_cert.cert.cert_pem
}

