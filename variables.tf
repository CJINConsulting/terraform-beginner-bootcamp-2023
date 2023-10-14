variable "teacherseat_user_uuid" {
  type = string
}

variable "terratowns_access_token" {
  type = string
}

variable "terratowns_endpoint" {
  type = string
}

variable "swos" {
  type = object({
    public_path     = string
    content_version = number
  })
}

variable "japan" {
  type = object({
    public_path     = string
    content_version = number
  })
}