terraform {
  required_providers {
    terratowns = {
      source  = "local.providers/local/terratowns"
      version = "1.0.0"
    }
  }

  cloud {
    organization = "colin_piper"

    workspaces {
      name = "terra-house-1"
    }
  }

}

provider "terratowns" {
  endpoint  = var.terratowns_endpoint
  user_uuid = var.teacherseat_user_uuid
  token     = var.terratowns_access_token
}

module "home_swos_hosting" {
  source          = "./modules/terrahome_aws"
  user_uuid       = var.teacherseat_user_uuid
  public_path     = var.swos.public_path
  content_version = var.swos.content_version
}

resource "terratowns_home" "home_swos" {
  name            = "Sensible World of Soccer (SWOS)"
  description     = <<DESCRIPTION
Sensible World of Soccer (SWOS), is a timeless classic that holds a special place in my heart. 
Released in the early 1990s, this football game was the pioneer for playable career modes.
  DESCRIPTION
  domain_name     = module.home_swos_hosting.domain_name
  town            = "gamers-grotto"
  content_version = var.swos.content_version
}

module "home_japan_hosting" {
  source          = "./modules/terrahome_aws"
  user_uuid       = var.teacherseat_user_uuid
  public_path     = var.japan.public_path
  content_version = var.japan.content_version
}

resource "terratowns_home" "home_japan" {
  name            = "Japan: A land of ancient culture, stunning scenery, and delicious food"
  description     = <<DESCRIPTION
Japan is a country in East Asia with a rich culture and history. 
It is known for its stunning scenery, delicious food, and friendly people. 
If you are looking for a unique and unforgettable travel experience, Japan is the perfect destination for you.
  DESCRIPTION
  domain_name     = module.home_japan_hosting.domain_name
  town            = "the-nomad-pad"
  content_version = var.japan.content_version
}