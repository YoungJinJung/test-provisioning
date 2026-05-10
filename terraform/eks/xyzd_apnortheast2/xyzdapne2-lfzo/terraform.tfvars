assume_role_arn = "arn:aws:iam::066346343248:role/terraform-runner"
# Basic Information
account_alias = "id"
product       = "xyz"

# Cluster information
cluster_version = "1.35"
release_version = "1.35.4-20260505"

# Service CIDR
service_ipv4_cidr = "172.20.0.0/16"

# EKS public endpoint access
public_access_cidrs = ["14.47.101.116/32"]

# Addon information
# https://docs.aws.amazon.com/eks/latest/userguide/managing-coredns.html
coredns_version = "v1.14.2-eksbuild.4"

# https://docs.aws.amazon.com/eks/latest/userguide/managing-kube-proxy.html
kube_proxy_version = "v1.35.3-eksbuild.5"

# https://docs.aws.amazon.com/eks/latest/userguide/managing-vpc-cni.html
vpc_cni_version = "v1.21.1-eksbuild.8"

# https://github.com/kubernetes-sigs/aws-ebs-csi-driver
ebs_csi_driver_version = "v1.59.0-eksbuild.1"

# https://github.com/aws/eks-pod-identity-agent
pod_identity_agent_version = "v1.3.10-eksbuild.3"

# Fargate Information
fargate_enabled      = false
fargate_profile_name = ""

# Node Group configuration
# Node Group configuration
node_group_configurations = [
  {
    name                = "ondemand_1_35_4-20260505"
    spot_enabled        = false
    release_version     = "1.35.4-20260505"
    disk_size           = 20
    ami_type            = "AL2023_x86_64_STANDARD"
    node_instance_types = ["t3.large"]
    node_min_size       = 2
    node_desired_size   = 2
    node_max_size       = 2
    labels = {
      "cpu_chip" = "intel"
    }
  },
  {
    name                = "spot_1_35_4-20260505"
    spot_enabled        = true
    disk_size           = 20
    release_version     = "1.35.4-20260505"
    ami_type            = "AL2023_x86_64_STANDARD"
    node_instance_types = ["t3.large"]
    node_min_size       = 2
    node_desired_size   = 2
    node_max_size       = 10
    labels = {
      "cpu_chip" = "intel"
    }
  },
]

additional_security_group_ingress = [
  {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["10.100.0.0/16"]
  }
]

access_entries = {
  accountadmin = {
    kubernetes_groups = []
    principal_arn     = "arn:aws:iam::066346343248:user/zerone"
    policy_associations = {
      kubeadmin = {
        policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
        access_scope = {
          namespaces = []
          type       = "cluster"
        }
      }
    }
  }
}

# Specified KMS ARNs accessed by ExternalSecrets
external_secrets_access_kms_arns = [
  "arn:aws:kms:ap-northeast-2:066346343248:key/79e6d15d-a3b1-431a-a6a2-ae9c63c25ddb"
]

# Specified SSM ARNs accessed by ExternalSecrets
external_secrets_access_ssm_arns = [
  "*"
]

# Specified SecretsManager ARNs accessed by ExternalSecrets
external_secrets_access_secretsmanager_arns = [
  "*"
]
