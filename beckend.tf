#Define onde serão armazenadas as informações de estado do terraform
terraform {
  backend "local" {
    path= "templates/terraform-state/terraform.tfstate"
  }
}
