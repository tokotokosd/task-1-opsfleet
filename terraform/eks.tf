# Configures the EKS cluster using the Terraform AWS EKS module.
# This setup includes the cluster configuration, node group setup, and IAM roles for access.
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.20.0"

  # Basic cluster configuration: name, networking, and version.
  cluster_name                   = "${var.environment}-eks-cluster"
  subnet_ids                     = module.vpc.private_subnets # Defines the subnets for the EKS cluster, using the VPC module.
  vpc_id                         = module.vpc.vpc_id # Defines the VPC for the EKS cluster, using the VPC module.
  cluster_version                = "1.28"

  # enable_irsa: Enables IAM Roles for Service Accounts, allowing Kubernetes service accounts to assume IAM roles.
  # cluster_endpoint_public_access: Configures the cluster API server endpoint to be accessible from outside the VPC(optional)
  enable_irsa                    = true
  cluster_endpoint_public_access = true

  # Defines the EKS managed node groups configuration.
  # eks_nodes: The name of the node group.
  # desired_capacity, max_capacity, min_capacity: Auto-scaling settings for the node group.
  # instance_type: The EC2 instance type for the worker nodes.
  # ami_type: The type of AMI used for the worker nodes, here set to Amazon Linux 2.
  eks_managed_node_groups = {
    eks_nodes = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1

      instance_type = "t2.micro"
      ami_type      = "AL2_x86_64"

      tags = var.default_tags
    }
  }

  # aws_auth_roles: Configures additional AWS IAM roles with access to the EKS cluster.
  # role_arn: The ARN of the IAM role.
  # username: The username within Kubernetes that the role will map to.
  # groups: Kubernetes RBAC groups that the role will belong to.
  aws_auth_roles = [{
    role_arn = aws_iam_role.eks_developer_role.arn
    username = "eks_dev"
    groups   = ["system:masters"]
  }]
}