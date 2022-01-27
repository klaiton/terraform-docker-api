#Define o provedor terraform a ser usado para comunicação com as APIs da AWS
provider "aws" {
  version = "~> 2.30"
  region  = var.region
}
