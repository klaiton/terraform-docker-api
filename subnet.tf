#Busca os ids das subnets na VPC
data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.main.id
}

#Busca as informações das subnets
data "aws_subnet" "all" {
  count = length(data.aws_subnet_ids.all.ids)
  id    = tolist(data.aws_subnet_ids.all.ids)[count.index]
}
