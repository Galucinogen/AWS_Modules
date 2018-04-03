variable "create_vpc_peering" {
  type        = "string"
  description = "The trigger for creating AWS VPC Peering"
}

variable "owner_vpc_id" {
  type        = "string"
  description = "The VPC ID of the VPC that owns the peer"
}

variable "peer_vpc_id" {
  type        = "string"
  description = "The VPC ID of the VPC to peer to"
}

variable "peer_account_id" {
  type    = "string"
  default = "The account ID of peer"
}

variable "owner_subnet_ids" {
  type        = "list"
  description = "The subnet IDs on the owner end to route to the peer"
}

variable "peer_subnet_ids" {
  type        = "list"
  description = "The subnet IDs on the peer end to route to the owner"
}

variable "owner_route_table_ids" {
  type        = "list"
  description = "The route table IDs on the owner end to add the peer routes to"
}

variable "peer_route_table_ids" {
  type        = "list"
  description = "The number of peer route tables to expect"
}

variable "owner_subnets" {
  type        = "list"
  description = "The owner of peer"
}

variable "peer_subnets" {
  type        = "list"
  description = "The subnnets of peer"
}
