module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.31.6"

  cluster_name                   = "test-cluster"
  cluster_version                = "1.31"
  cluster_endpoint_public_access = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  enable_cluster_creator_admin_permissions = true

  cluster_compute_config = {
    enabled    = true
    node_pools = ["general-purpose"]
  }
}

data "aws_iam_policy_document" "allow_pod_identity" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]
  }
}

resource "aws_iam_role" "read_dynamodb" {
  name               = "read-dynamodb-role"
  assume_role_policy = data.aws_iam_policy_document.allow_pod_identity.json
}

resource "aws_iam_role_policy_attachment" "read_dynamodb" {
  role       = aws_iam_role.read_dynamodb.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBReadOnlyAccess"
}

resource "aws_eks_pod_identity_association" "read_dynamodb" {
  cluster_name    = module.eks.cluster_name
  namespace       = "app"
  service_account = "app-sa"
  role_arn        = aws_iam_role.read_dynamodb.arn
}
