variable "role_name" {
  description = "role_name"
  default     = "terraform-runner"
}

variable "role_path" {
  description = "role_path"
  default     = "/"
}

variable "max_session_duration" {
  description = "max_session_duration"
  default     = "14400"
}

variable "principal_account_id" {
  description = "principal account id"
}

variable "account_id" {
  description = "account id"
}