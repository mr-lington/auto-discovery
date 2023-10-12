# Import Route53 Hosted Zone
data "aws_route53_zone" "zone" {
  name         = var.domain-name
  private_zone = false
}

# Create Route 53 record for the stage environment
resource "aws_route53_record" "stage" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = var.domain-name-stage
  type    = "A"

  alias {
    name                   = var.stage-lb-dns-name
    zone_id                = var.stage-lb-zone-id
    evaluate_target_health = false
  }
}

# Create Route 53 record for the prod environment
resource "aws_route53_record" "prod" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = var.domain-name-prod
  type    = "A"

  alias {
     name                   = var.prod-lb-dns-name
     zone_id                = var.prod-lb-zone-id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "jenkins" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = var.domain-name-jenkins
  type    = "A"

  alias {
     name                   = var.jenkins-lb-dns-name
     zone_id                = var.jenkins-lb-zone-id
    evaluate_target_health = false
  }
}