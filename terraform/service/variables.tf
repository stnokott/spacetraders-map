variable "env" {
  type = string

  validation {
    condition     = contains(["dev", "prod"], var.env)
    error_message = "env needs to be one of [\"dev\", \"prod\"]."
  }
}
