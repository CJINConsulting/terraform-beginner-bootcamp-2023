terraform {
  required_providers {
    terratowns = {
      source = "local.providers/local/terratowns"
      version = "1.0.0"
    }
  }

  # cloud {
  #   organization = "colin_piper"

  #   workspaces {
  #     name = "terra-house-1"
  #   }
  # }

}

provider "terratowns" {
  endpoint = "http://localhost:4567/api"
  user_uuid = "e328f4ab-b99f-421c-84c9-4ccea042c7d1"
  token = "9b49b3fb-b8e9-483c-b703-97ba88eef8e0"
}

# module "terrahouse_aws" {
#   source              = "./modules/terrahouse_aws"
#   user_uuid           = var.user_uuid
#   bucket_name         = var.bucket_name
#   index_html_filepath = var.index_html_filepath
#   error_html_filepath = var.error_html_filepath
#   content_version     = var.content_version
#   assets_path         = var.assets_path
# }

resource "terratowns_home" "home" {
  name = "Games that "
  description = <<DESCRIPTION
These are games from my childhood that were fun to play.
This page gives a brief description of those games and some reasons
why you should try them!
  DESCRIPTION
  domain_name = "pooplydooply.cloudfront.net"
  town = "gamers-grotto"
  content_version = 1
}