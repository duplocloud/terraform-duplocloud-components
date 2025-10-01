variable "tenant" {
  description = "The tenant name"
  type        = string
}

variable "file" {
  description = "The path to the docker-compose file"
  type        = string
}

variable "args" {
  description = <<EOF
  These are the environment variable arguments for the compose file itself. For example if the image is something like $IMAGE:$TAG you can pass in IMAGE and TAG values to replace the variables in the compose file.
  EOF
  type = map(string)
  default = {}
}
