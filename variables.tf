variable "win_username" {
  description = "Windows node username"
  type        = string
  sensitive   = false
#   default = "admin.tftec"
}

variable "win_userpass" {
  description = "Windows node password"
  type        = string
  sensitive   = true
#   default = "*********"
}