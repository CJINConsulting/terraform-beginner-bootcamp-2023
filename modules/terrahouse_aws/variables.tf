variable "user_uuid" {
  description = "The UUID of the user"
  type        = string

  validation {
    condition     = can(regex("^([0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12})$", var.user_uuid))
    error_message = "Invalid user UUID format. Must be in the format of a UUID (e.g., 123e4567-e89b-12d3-a456-426655440000)"
  }
}

variable "bucket_name" {
  description = "AWS S3 bucket name"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9.-]{3,63}$", var.bucket_name))
    error_message = "Invalid bucket name. It must be between 3 and 63 characters long and contain only lowercase letters, numbers, hyphens, and periods."
  }
}

variable "index_html_filepath" {
  description = " The file path for index.html"
  type = string
  validation {
    condition = fileexists(var.index_html_filepath)
    error_message = "The provided path for index.html does not exist"
  } 
}

variable "error_html_filepath" {
  description = " The file path for error.html"
  type = string
  validation {
    condition = fileexists(var.error_html_filepath)
    error_message = "The provided path for error.html does not exist"
  } 
}

variable "content_version" {
  type        = number
  description = "The content version. Should be a postive integer."
  validation {
    condition     = var.content_version >= 1 && ceil(var.content_version) == floor(var.content_version)
    error_message = "Value must be a positive integer starting from 1"
  }
}

variable "assets_path" {
  description = "Path to the assets folder"
  type = string
}