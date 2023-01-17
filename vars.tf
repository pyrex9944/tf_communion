variable "aws_region" {
    default = "eu-central-1"
}

variable "instance_type" {
    type        = string
    description = "Instance type for EC2"
    default = "t2.micro"
}

variable "volume_type" {
    type        = string
    description = "Volume type for EC2"
    default = "gp2"
}

variable "volume_type" {
    type        = number
    description = "Volume type for EC2"
    default = 20
}



variable "ami" {
    type        = string
    description = "Instance AMI for eu-central-1 region ubuntu 22.04"
    default = "ami-0039da1f3917fa8e3"
}

variable "environment" {
    type        = string
    description = "Staging Enviroment"
    default     = "staging"
}

variable "project_tags" {
    type        = map(string)
    description = "Tags used for aws"
    default     = {
        Project     = "communion-staging"
        Owner       = "Sirojiddin"
        Terraform   = "true"
    }
}

variable "vpc_cidr" {
    type        = string
    description = "CIDR block of the vpc"
    default     = "10.0.0.0/16"
}

variable "private_subnets_cidr" {
    type        = string
    description = "CIDR block for Private Subnet"
    default     = "10.0.1.0/24"
}

variable "public_subnets_cidr" {
    type        = string
    description = "CIDR block for Private Subnet"
    default     = "10.0.0.0/24"
}

variable "availability_zones" {
    type        = list(string)
    description = "AZ in which all the resources will be deployed"
    default     = ["eu-central-1a"]
}