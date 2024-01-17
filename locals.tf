locals {

  az_name=slice(data.aws_availability_zones.azs.names,0,2)
  name= "${var.project_name}-${var.environment}"

}