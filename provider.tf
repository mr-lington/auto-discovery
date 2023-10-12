# Configure the AWS Provider
provider "aws" {
  region  = var.region  # region  = "eu-west-3"  # region = data.vault_generic_secret.aws-cred.data["region"]
  profile = var.profile # profile = "lington"
  # access_key = data.vault_generic_secret.aws-cred.data["aws_access_key_id"]
  # secret_key = data.vault_generic_secret.aws-cred.data["aws_secret_access_key"]
}

# provider "vault" {
#   address = "https://greatestshalomventures.com"
#   token   = "s.t7W7GMrkGqza7inYtOAnD1nC"
# }
# data "vault_generic_secret" "aws-cred" {
#   path = "sec/aws-credential"
# }
# data "vault_generic_secret" "database" {
#   path = "sec/database"
# }