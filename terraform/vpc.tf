# Fetches the list of available Availability Zones in the current region.
# This is used to distribute subnets across multiple AZs for high availability.
data "aws_availability_zones" "available" {}

# Configures a VPC using the terraform-aws-modules/vpc/aws module.
# This VPC setup includes both public and private subnets, as well as NAT gateways for outbound internet access.
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  # Basic VPC configuration: name and CIDR block.
  name = "my-vpc"
  cidr = "10.0.0.0/16"

  # Availability Zones (AZs) and Subnet Configuration:
  azs             = data.aws_availability_zones.available.names
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  # NAT Gateway Configuration:
  # enable_nat_gateway: Enables the creation of a NAT gateway.
  # single_nat_gateway: Use a single NAT gateway for all private subnets (cost-saving option).
  # enable_dns_hostnames: Allows instances in the VPC to have DNS hostnames.
  # enable_dns_support: Allows instances in the VPC to resolve public DNS hostnames.
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true
}

# Create a VPC Endpoint for Amazon S3. This allows private access to S3 from within the VPC.
resource "aws_vpc_endpoint" "s3" {
  vpc_id             = module.vpc.vpc_id
  service_name       = "com.amazonaws.${var.region}.s3"

  # The type of VPC endpoint. For S3, a Gateway endpoint is used.
  vpc_endpoint_type  = "Gateway"

  # Associates the endpoint with route tables of the VPC.
  route_table_ids    = module.vpc.private_route_table_ids

  # Optional policy to control access to S3 from the VPC endpoint.
  # If not specified, the default policy allows full access to S3.
  # You can modify this policy to restrict access to specific S3 buckets.
  policy             = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:*",
      "Resource": ["arn:aws:s3:::*"]
    }
  ]
}
POLICY

  # Tag for identifying the VPC Endpoint resource.
  tags = {
    Name        = "s3-vpc-endpoint"
  }
}