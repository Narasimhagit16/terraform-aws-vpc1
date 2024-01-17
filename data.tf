# Declare the data source
data "aws_availability_zones" "azs" {
  state = "available"
}

data "aws_vpc" "data_default_vpc" {
  default = true
}

data "aws_route_table" "default_route_table" {
  vpc_id = data.aws_vpc.data_default_vpc.id
  
}