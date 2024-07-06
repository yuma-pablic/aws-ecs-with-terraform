variable "service" {
  description = "The name of the service"
  type        = string
  default     = "sbcntr"
}
variable "env" {
  description = "The environment of the service"
  type        = string
  default     = "dev"
}

variable "ecspresso_env_dir" {
  description = "The ARN of the blue listener"
  type        = string
  default     = "../../../api/"
}
