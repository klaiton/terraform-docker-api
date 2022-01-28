# Terraform Docker Web Application
## _Aplicação web em contêiner, na aws por meio de infraestrutura como código (IaC)_


A aplicação web usada: https://github.com/mesaugat/express-api-es6-starter.git



##  Pré -requisitos

- [ Terraform ](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- [ aws-vault ](https://github.com/99designs/aws-vault.git)
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
Iniciaize o terraform no projeto.
```sh
terraform init
```
Execute comandos com sua credencial AWS para o deploy da infraestrutura.
```sh
aws-vault exec <usuário>  -- bash
terraform apply
```
Após o apply, vai ser exposto no terminal o IP da instância EC2 criada.
Exemplo:
```sh
Outputs:

publicIP = "54.00.00.00"
```
Verifique a aplicação em http://54.00.00.00:8848/api/
- Pode ser que demore para subir os contêineres na instância, para verificar o log do cloud init no userdata, acesse a instância via ssh e faça o comando:
```sh
sudo cat /var/log/cloud-init-output.log
```

Para desmontar a infraestrutura.
```sh
terraform destroy
```
##  Considerações
- Para acessar a instância via SSH é nescessário modificar o key_name do recurso "aws_instance" do EC2, e o key_name do recurso aws_launch_configuration. Crie um par de chaves no Amazon EC2 da sua conta AWS, e moficique ou adicione em "ssh-authorized-keys: o conteudo da sua chave publica no cloud-config.

- Para facilitar o acesso, foi implementado em sg.tf o _ingress_ para a porta 22 o acesso a qualquer IP, por segurança o correto é implementar para localhost.


