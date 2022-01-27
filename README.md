# Terraform Docker Web Aplication
## _Aplicação web em contêiner, na aws por meio de infraestrutura como código (IaC)_


A aplicação web usada: https://github.com/mesaugat/express-api-es6-starter.git



##  Pré -requisitos

- [ Terraform ](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- [ aws-vault ](https://github.com/99designs/aws-vault.git)
- [ Docker ](https://docs.docker.com/engine/install/ubuntu/)
- [ Docker-compose ](https://docs.docker.com/compose/install/)
- [ IAM ](https://docs.aws.amazon.com/pt_br/IAM/latest/UserGuide/id_users_create.html)
##  Configuração do aws-vault 
O AWS Vault é uma ferramenta para armazenar e acessar com segurança as credenciais da AWS em um ambiente de desenvolvimento.
_Nescessário para o deploy do terraform._

```sh
brew install aws-vault
```
Crie um usuário do IAM na sua conta aws e adicione no aws-vault.
```sh
aws-vault add <usuário>
Enter Access Key Id: ABDCDEFDASDASF
Enter Secret Key: %%%
```
##  Deploy Terraform 
Execute comandos com sua credencial aws para o deploy da infraestrutura.
```sh
aws-vault exec <usuário>  -- bash
terraform apply
```
Para desmontar a infraestrutura.
```sh
terraform destroy
```
