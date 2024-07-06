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
  description = "The path to the directory containing the ecspresso configuration file"
  type        = string
  default     = "../../../api/"
}
