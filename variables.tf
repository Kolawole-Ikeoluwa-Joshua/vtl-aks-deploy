# --- root/variables.tf ---
variable "serviceprinciple_id" {
}

variable "serviceprinciple_key" {
}

variable "tenant_id" {
}

variable "subscription_id" {
}


variable "ssh_key" {
}

variable "location" {
  description = "The location of the resources"
  default     = "North Europe"
}

variable "kubernetes_version" {
  default = "1.22.2"
}