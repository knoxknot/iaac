variable "access_key" {
  description = "AWS access key"
  type        = "string"
}

variable "any_ip" {
  default     = "0.0.0.0/0"
  description = "Any IP Address"
  type        = "string"
}

variable "http_port" {
  default     = "80"
  description = "The Communication Port for HTTP Requests"
  type        = "string"
}

variable "instance_type" {
  description = "AWS Istance Type"
  type        = "string"
}

variable "project" {
  description = "The Project Name"
  type        = "string"
}

variable "region" {
  description = "AWS Region"
  type        = "string"
}

variable "secret_key" {
  description = "AWS secret key"
  type        = "string"
}

variable "ssh_port" {
  default     = "22"
  description = "The Secured Shell Communication Port"
  type        = "string"
}