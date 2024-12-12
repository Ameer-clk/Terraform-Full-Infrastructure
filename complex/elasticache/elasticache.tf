resource "aws_elasticache_cluster" "tfer--redis-cache-001" {
  auto_minor_version_upgrade = "false"
  availability_zone          = "eu-west-2a"
  cluster_id                 = "redis-cache-001"
  ip_discovery               = "ipv4"
  network_type               = "ipv4"
  replication_group_id       = "${aws_elasticache_replication_group.tfer--redis-cache.replication_group_id}"
  transit_encryption_enabled = "false"
}
