variable "file" {
  description = "The path to the file to load"
  default = null
  nullable = true
}

variable "content" {
  description = "The contents of the file"
  type = string
  default = null
  nullable = true
}


