variable "environment" {
  default = "dev"
}

variable "aws_region" {
  default = "ap-southeast-1"
}

### EC2 Values ###
variable "instance_type" {
  type        = string
  description = "Define the EC2 Instance type for the ecs cluster"
  default     = "t2.micro"
}

### ECS Values ###
variable "container_image" {
  type        = string
  description = "Define what docker image will be deployed to the ECS task"
  default     = "nginx-app"
}

variable "ami_id" {
  default = "ami-6944c513"
}

variable "ami_owners" {
  default = ["self", "amazon", "aws-marketplace"]
}

variable "cpu_credit_specification" {
  default = "standard"
}

variable "detailed_monitoring" {
  default = false
}

variable "lookup_latest_ami" {
  default = false
}

variable "root_block_device_type" {
  default = "gp2"
}

variable "root_block_device_size" {
  default = "8"
}

variable "health_check_grace_period" {
  default = "600"
}

variable "desired_capacity" {
  default = "1"
}

variable "min_size" {
  default = "1"
}

variable "max_size" {
  default = "1"
}

variable "enabled_metrics" {
  default = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances",
  ]

  type = list(string)
}