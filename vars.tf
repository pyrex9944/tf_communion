variable "AWS_REGION" {
    default = "eu-central-1"
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