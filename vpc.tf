#Busca pela VPC
data "aws_vpc" "main" {
  default = true
}