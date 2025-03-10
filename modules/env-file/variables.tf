variable "file" {
  description = "The path to the file to load."
  default     = null
  type        = string
  nullable    = true
  validation {
    condition = (
      (var.content != null || var.file != null) &&
      !(var.content != null && var.file != null)
    )
    error_message = "Either file or content must be set, but not both."
  }
}

variable "content" {
  description = "The contents of the file"
  type        = string
  default     = null
  nullable    = true
}
