# AWS EKS Infrastructure and Application Deployment

This repository contains the necessary Terraform configurations and Kubernetes templates for setting up an AWS EKS cluster and deploying a sample application with S3 access.

## Repository Structure

- `/terraform`: Contains all Terraform configuration files.
- `/kubernetes`: Contains Kubernetes deployment templates.
- `README.md`: This file, providing guidance on how to use the repository.

## Prerequisites

- AWS account with appropriate permissions.
- Terraform installed.
- AWS CLI installed and configured.
- `kubectl` installed and configured for EKS cluster access.

## Usage

### Setting Up the Infrastructure

1. Navigate to the `/terraform` directory.
2. Update the `variables.tf` file with appropriate values for your environment.
4. Apply the Terraform configurations with `terraform apply`.

### Deploying the Kubernetes Application

1. Navigate to the `/kubernetes` directory.
2. Update the `app.yaml` file, replacing `{AWS_ACCOUNT_ID}` with your actual AWS account ID in the service account annotation.
3. Apply the Kubernetes configuration with `kubectl apply -f app.yaml`.

### Assuming Roles for Developers

Developers can assume the `eks-developer-role` for managing the EKS cluster and its resources:

1. Use the AWS CLI to assume the role: `aws sts assume-role --role-arn arn:aws:iam::{AWS_ACCOUNT_ID}:role/eks-developer-role --role-session-name eks-session`.
2. Configure your AWS CLI with the credentials returned from the above command.