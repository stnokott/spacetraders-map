variable "env" {
  type = string

  validation {
    condition     = contains(["dev", "preprod", "prod"], var.env)
    error_message = "env needs to be one of [\"dev\", \"preprod\", \"prod\"]."
  }
}

variable "image_tag" {
  type        = string
  description = "Image tag to be deployed."
}
