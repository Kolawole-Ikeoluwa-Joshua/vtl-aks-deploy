variable "serviceprinciple_id" {
}

variable "serviceprinciple_key" {
}

variable "location" {
  description = "The location of the resources"
  default     = "North Europe"
}

variable "kubernetes_version" {
  default = "1.22.2"
}

variable "ssh_key" {
}