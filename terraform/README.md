# AWS EKS Terraform Configuration

This repository contains Terraform code to deploy an Amazon EKS cluster along with the necessary VPC, IAM roles, and an S3 VPC Endpoint for enhanced networking and security.

## Prerequisites

- AWS Account with appropriate permissions
- Terraform installed
- AWS CLI installed and configured

## Configuration Files

- `eks.tf`: Sets up the EKS cluster.
- `vpc.tf`: Configures the VPC, including subnets and NAT gateways.
- `app-role.tf`: Creates an IAM role for Kubernetes pods to interact with AWS services.
- `eks-user.tf`: Creates an IAM user for accessing the EKS cluster.
- `variables.tf`: Contains variables used across the configurations.
- `main.tf`: Defines the provider and backend configurations.
- `terraform.tf`: Defines the Terraform version.

## Variables

- `region`: AWS region for resource deployment.
- `environment`: Deployment environment (e.g., dev, prod).
- `default_tags`: Default tags applied to all resources.

## Setup Instructions

1. **Initialize Terraform:**
   - Run `terraform init` to initialize the Terraform environment and download necessary providers.

2. **Plan Deployment:**
   - Execute `terraform plan` to review the changes that Terraform will perform.

3. **Apply Configuration:**
   - Run `terraform apply` to apply the configuration and create the resources.

## EKS Cluster Access

- To access the EKS cluster, ensure your AWS CLI is configured with the necessary credentials.
- Use `aws eks update-kubeconfig --name [CLUSTER_NAME] --region [REGION]` to update your `kubeconfig` file.
- Test the access using `kubectl get nodes` to list the worker nodes in the cluster.

## IAM Role for Kubernetes Pods

- Pods in EKS can assume the IAM role defined in `app-role.tf` for accessing AWS services like S3.
- Ensure your Kubernetes service accounts are correctly annotated with the IAM role ARN.

## VPC Configuration

- The VPC is configured with public and private subnets.
- An S3 VPC Endpoint is created for private access to S3, bypassing the public internet.

## Notes

- Modify the `variables.tf` file to customize the deployment as per your requirements.
- Always review the Terraform plan before applying the changes.
