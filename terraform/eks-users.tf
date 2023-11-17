# Creates an IAM role for EKS developers.
# This role defines the permissions for developers working with the EKS cluster.
resource "aws_iam_role" "eks_developer_role" {
  # The name of the IAM role.
  name = "eks-developer-role"

  # The assume role policy document allows entities (like EKS service) to assume this role.
  # Here, it specifically allows the EKS service to assume this role.
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "eks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attaches a predefined AWS policy to the EKS developer role.
# The policy grants the necessary permissions for managing EKS clusters.
resource "aws_iam_role_policy_attachment" "eks_developer_policy" {
  role       = aws_iam_role.eks_developer_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}
