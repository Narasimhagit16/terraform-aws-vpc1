resource "aws_vpc_peering_connection" "peering" {
  count = var.is_peering_required ? 1 : 0
  vpc_id      = aws_vpc.main.id
  peer_vpc_id = var.acceptor_vpc_id == "" ? data.aws_vpc.data_default_vpc.id : var.acceptor_vpc_id
  auto_accept = var.acceptor_vpc_id == "" ? true : false

  tags = merge(var.common_tags, var.peering_tags ,
    {
        Name = "${local.name}"
    }
  )    
}


resource "aws_route" "acceptor_route" {
  count = var.is_peering_required && var.acceptor_vpc_id =="" ? 1 : 0
  route_table_id            = data.aws_route_table.default_route_table.id
  destination_cidr_block    = var.vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id
}

resource "aws_route" "peering_public_peering_route" {
  count = var.is_peering_required && var.acceptor_vpc_id =="" ? 1:0
  route_table_id            = aws_route_table.public_route_table.id
  destination_cidr_block    = data.aws_vpc.data_default_vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id
}

resource "aws_route" "peering_private_peering_route" {
  count = var.is_peering_required && var.acceptor_vpc_id =="" ? 1:0
  route_table_id            = aws_route_table.private_route_table.id
  destination_cidr_block    = data.aws_vpc.data_default_vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id
}

resource "aws_route" "peering_database_peering_route" {
  count = var.is_peering_required && var.acceptor_vpc_id =="" ? 1:0
  route_table_id            = aws_route_table.database_route_table.id
  destination_cidr_block    = data.aws_vpc.data_default_vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id
}

