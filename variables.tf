variable "vpc_cidr" {
    type=string
    default = "10.0.0.0/16"
  
}

variable "enable_dns_hostnames" {
  
  type=bool
  default = true
}

variable "common_tags" {
    type = map
    default = {}
}

variable "vpc_tags" {
    type = map
    default = {}
}

variable "project_name" {
    type=string
      
}

variable "environment" {
  type=string
}
 
variable "igw_tags" {
    type = map
    default = {}
}

variable "public_subnet_cidr" {
    type = list
    validation {
      condition = length(var.public_subnet_cidr) == 2
      error_message = "plase give 2 valid  public subnet CIDR"
    }
}


variable "private_subnet_cidr" {
    type = list
    validation {
      condition = length(var.private_subnet_cidr) == 2
      error_message = "plase give 2  valid private subnet CIDR"
    }
}

variable "subnet_tags" {
    default = {}  
}

variable "database_subnet_cidr" {
    type = list
    validation {
      condition = length(var.database_subnet_cidr) == 2
      error_message = "plase give 2  valid database subnet CIDR"
    }
}


variable "nat_gw_tags" {
  default = {}

}

variable "public_route_tags" {
  default={}
  
}

variable "private_route_tags" {
  default={}
  
}

variable "database_route_tags" {
  default = {}
  
}

variable "is_peering_required" {
  type=bool
  default = false
  
}

variable "acceptor_vpc_id" {
  type = string
  default = ""
  
}

variable "peering_tags" {
  default = {}
}