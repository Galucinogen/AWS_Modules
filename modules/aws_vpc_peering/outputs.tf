output "vpc_peer_id" {
  value       = "${element(split(",", join(",", aws_vpc_peering_connection.vpc_peer.*.id)), 0)}"
  description = "The VPC peer ID"
}
