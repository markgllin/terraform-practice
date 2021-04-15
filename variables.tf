variable "environment" {
  type        = string
  description = "Environment to place ECS cluster"
  default     = "qa"
}

######## Autoscaling Group ########
variable "min_ec2_instance_count" {
  type        = number
  description = "Minimum # of EC2 instances in autoscaling group"
  default     = 2
}

variable "max_ec2_instance_count" {
  type        = number
  description = "Maximum # of EC2 instances in autoscaling group"
  default     = 5
}

variable "ec2_instance_type" {
  type        = string
  description = "EC2 instance type to use in AWS Launch Configuration"
  default     = "t2.nano"
}

######## ECS Cluster ########
variable "cluster_name" {
  type        = string
  description = "Name of ECS cluster"
  default     = "ecs-cluster"
}

variable "container_name" {
  type        = string
  description = "Name of container in task definition"
  default     = "helloworld"
}

variable "container_port" {
  type        = string
  description = "Container port"
  default     = "80"
}

variable "image_url" {
  type        = string
  description = "URL of image to use in ECS"
  default     = "registry-1.docker.io/markgllin/python-flask-helloworld"
}

variable "desired_ecs_svc_count" {
  type        = number
  description = "Desired # of ECS services to spin up in ECS cluster"
  default     = 2
}

######## CloudWatch Alert ########
variable "notification_email" {
  type        = string
  description = "Notification email to use to subscribe to CloudWatch alerts"
  default     = "markgllin@gmail.com"
}