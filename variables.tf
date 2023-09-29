variable "user_uuid" {
  description = "The UUID of the user"
  type = string
  validation {
        condition     = can(regex("^([0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12})$", var.user_uuid))
        error_message = "Invalid user UUID format. Must be in the format of a UUID (e.g., 123e4567-e89b-12d3-a456-426655440000)"
  }
}