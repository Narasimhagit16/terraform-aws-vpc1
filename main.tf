resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge(var.common_tags, var.vpc_tags
            ,
            {
                Name = "${var.project_name}-${var.environment}"
            }
            )

  }

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.common_tags, var.igw_tags
            ,
            {
                Name = local.name
            }
            )
}


resource "aws_subnet" "public_subnet" {
  count = length(var.public_subnet_cidr)

  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidr[count.index]
  availability_zone = local.az_name[count.index]

  tags = merge(var.common_tags, var.subnet_tags
            ,
            {
               Name = "${local.name}-${local.az_name[count.index]}"
            }
            )
}


resource "aws_subnet" "private_subnet" {
  count = length(var.private_subnet_cidr)

  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidr[count.index]
  availability_zone = local.az_name[count.index]

  tags = merge(var.common_tags, var.subnet_tags
            ,
            {
               Name = "${local.name}-${local.az_name[count.index]}"
            }
            )
}

resource "aws_subnet" "database_subnet" {
  count = length(var.database_subnet_cidr)

  vpc_id     = aws_vpc.main.id
  cidr_block = var.database_subnet_cidr[count.index]
  availability_zone = local.az_name[count.index]

  tags = merge(var.common_tags, var.subnet_tags
            ,
            {
                Name = "${local.name}-${local.az_name[count.index]}"
            }
            )
} 


resource "aws_eip" "eip" {
  domain   = "vpc"
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_subnet[0].id

   tags = merge(var.common_tags, var.nat_gw_tags,
    {
      Name = "${local.name}"
       }

   )


  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

 tags = merge(var.common_tags, var.public_route_tags
            ,
            {
                Name = "${local.name}-public"
            }
            )
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main.id

 tags = merge(var.common_tags, var.private_route_tags
            ,
            {
                Name = "${local.name}-private"
            }
            )
}

resource "aws_route_table" "database_route_table" {
  vpc_id = aws_vpc.main.id

 tags = merge(var.common_tags, var.database_route_tags
            ,
            {
                Name = "${local.name}-database"
            }
            )
}

resource "aws_route" "public_route" {
  route_table_id            = aws_route_table.public_route_table.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.gw.id
}

resource "aws_route" "private_route" {
  route_table_id            = aws_route_table.private_route_table.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat_gw.id
}

resource "aws_route" "database_route" {
  route_table_id            = aws_route_table.database_route_table.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat_gw.id
}

resource "aws_route_table_association" "public_associate" {
  count = length(var.public_subnet_cidr)
  subnet_id      = element(aws_subnet.public_subnet[*].id, count.index) 
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_associate" {
  count = length(var.private_subnet_cidr)
  subnet_id      = element(aws_subnet.private_subnet[*].id, count.index) 
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "database_associate" {
  count = length(var.database_subnet_cidr)
  subnet_id      = element(aws_subnet.database_subnet[*].id, count.index) 
  route_table_id = aws_route_table.database_route_table.id
}