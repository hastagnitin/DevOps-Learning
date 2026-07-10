variable "aws_region" {
  description = ""
  type        = string
  default     = "ap-south-1" 
}

variable "instance_type" {
  description = ""
  type        = string
  default     = "t2.micro" 
}

variable "ami_id" {
  description = "Ubuntu 24.04 LTS"
  type        = string
  default     = "ami-03f4878755434977f" 
}

variable "server_name" {
  description = ""
  type        = string
  default     = "My-Practice-Server"
}