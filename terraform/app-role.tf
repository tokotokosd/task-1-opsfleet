# Fetches the AWS account identity details, primarily used to retrieve the account ID.
data "aws_caller_identity" "current" {}

# Local variables for easy reference and maintainability.
# aws_account_id: The AWS account ID for referencing in IAM roles.
# eks_cluster_oidc_issuer: The OIDC issuer URL extracted from the EKS module, used in IAM role trust relationships.
# eks_service_account_name: The name of the Kubernetes service account that will be linked to the IAM role.
# eks_service_account_namespace: The Kubernetes namespace where the service account resides.
locals {
  aws_account_id          = data.aws_caller_identity.current.account_id
  eks_cluster_oidc_issuer = module.eks.oidc_provider

  eks_service_account_name      = "s3-access-sa"
  eks_service_account_namespace = "default"
}


# Creates an IAM role specifically for IRSA (IAM Roles for Service Accounts) in EKS.
# This IAM role is associated with a Kubernetes service account, allowing applications
# running on EKS to assume this role and gain AWS permissions defined in attached policies.
# For detailed guidance, refer to the AWS EKS User Guide:
# https://docs.aws.amazon.com/eks/latest/userguide/associate-service-account-role.html
resource "aws_iam_role" "app_role" {
  name = "eks-s3-role"

  # The trust relationship policy document that grants an entity permission to assume the role.
  # In this case, it allows the EKS service account to assume this role via OpenID Connect (OIDC).
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = "arn:aws:iam::${local.aws_account_id}:oidc-provider/${local.eks_cluster_oidc_issuer}"
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "${local.eks_cluster_oidc_issuer}:aud" = "sts.amazonaws.com",
            "${local.eks_cluster_oidc_issuer}:sub" = "system:serviceaccount:${local.eks_service_account_namespace}:${local.eks_service_account_name}"
          }
        }
      }
    ]
  })
}


# Attaches the AmazonS3FullAccess policy to the created IAM role.
# This policy grants the service account full access to S3 services.
# Modify this policy attachment to adhere to the principle of least privilege based on application requirements.
resource "aws_iam_role_policy_attachment" "app_role_policy_attachment" {
    role       = aws_iam_role.app_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}