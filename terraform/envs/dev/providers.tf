provider "aws" {
    region = var.aws_region
}


# Configurados tras crear el cluster (data de kubeconfig)
provider "kubernetes" {
    host = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    token = data.aws_eks_cluster_auth.this.token
}


data "aws_eks_cluster_auth" "this" {
    name = module.eks.cluster_name
}


provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}
