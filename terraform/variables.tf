# Variable to specify the AWS region where resources will be created.
# This allows for easy modification and reuse of the Terraform code across different AWS regions.
variable "region" {
  description = "AWS region where the resources will be deployed."
  type        = string
  default     = "eu-central-1"
}

# Variable to define the environment (like dev, test, prod) for resource deployment.
# This can be used to differentiate resources across various stages of development.
variable "environment" {
  description = "The deployment environment, e.g., 'dev', 'prod', 'test'."
  type        = string
  default     = "dev"
}

# Variable for setting default tags that will be applied to all AWS resources.
# Tags are key-value pairs used for resource identification and management.
# Default tags include the owner's email, the environment, and a flag indicating Terraform management.
variable "default_tags" {
  description = "Default tags to be applied to all resources for identification and management."
  type        = map(string)
  default     = { 
    "Owner"       : "tornike.archvadze@dataart.com", 
    "Environment" : "dev", 
    "Terraform"   : "true" 
  }
}
