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
  endpoint = var.terratowns_endpoint
  user_uuid = var.teacherseat_user_uuid
  token = var.terratowns_access_token
}

module "terrahouse_aws" {
  source              = "./modules/terrahouse_aws"
  user_uuid           = var.teacherseat_user_uuid
  index_html_filepath = var.index_html_filepath
  error_html_filepath = var.error_html_filepath
  content_version     = var.content_version
  assets_path         = var.assets_path
}

resource "terratowns_home" "home" {
  name = "Sensible World of Soccer (SWOS)"
  description = <<DESCRIPTION
Sensible World of Soccer (SWOS), is a timeless classic that holds a special place in my heart. 
Released in the early 1990s, this football game was the pioneer for playable career modes.
  DESCRIPTION
  domain_name = module.terrahouse_aws.cloudfront_url
  town = "missingo"
  content_version = 2
}