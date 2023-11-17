# Kubernetes Pod Configuration for S3 Access

This guide explains how to deploy a Kubernetes pod in the Amazon EKS cluster, which is configured to access AWS S3 using a service account linked to an IAM role, and how developers can assume the `eks-developer-role` for cluster management.

## Prerequisites

- Access to the EKS cluster
- `kubectl` configured to communicate with your EKS cluster
- AWS CLI installed and configured
- Permissions to create service accounts and pods in the Kubernetes namespace
- Permission to assume the `eks-developer-role` IAM role

## Overview

The `app.yaml` file contains the configuration to create a Kubernetes service account and a pod. The service account is annotated with an IAM role ARN, which provides the necessary permissions to access AWS S3. The pod uses this service account to interact with S3 using the AWS CLI.

## Deployment Steps

1. **Assuming the eks-developer-role:**
   - Ensure you have the necessary permissions to assume the `eks-developer-role`.
   - Use the AWS CLI to assume the role: `aws sts assume-role --role-arn arn:aws:iam::{AWS_ACCOUNT_ID}:role/eks-developer-role --role-session-name eks-session`.
   - Configure your AWS CLI with the credentials returned from the above command.

2. **Update the Service Account IAM Role ARN:**
   - Replace `{AWS_ACCOUNT_ID}` in the `eks.amazonaws.com/role-arn` annotation with your actual AWS account ID.
   - Ensure the IAM role (`eks-s3-role`) exists and has the necessary permissions to access S3.

3. **Apply the Configuration:**
   - Run `kubectl apply -f app.yaml` to create the service account and the pod in your Kubernetes cluster.

4. **Verify the Pod Execution:**
   - Use `kubectl get pods` to check the status of the `s3-access-pod`.
   - Once the pod is running, you can check its logs using `kubectl logs s3-access-pod` to see the output of the S3 list command.

## Notes

- The pod in this example uses the AWS CLI to list S3 buckets. You can modify the pod's command in `app.yaml` to perform other S3 operations as needed.
- Ensure that the EKS cluster is configured with IAM Roles for Service Accounts (IRSA) and that the OIDC provider is set up correctly in AWS IAM.


