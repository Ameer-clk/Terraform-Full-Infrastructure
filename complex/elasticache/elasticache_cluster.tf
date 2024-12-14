resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = "redis-subnet-group"
  subnet_ids = ["subnet-024bb03db545aaf28", "subnet-0d1fde223f647df84"] # Replace with your private subnet IDs
}

resource "aws_elasticache_cluster" "redis_cache_cluster" {
  cluster_id                 = "redis-cache-cluster"
  engine                     = "redis"
  engine_version             = "7.1"
  node_type                  = "cache.t3.medium"
  num_cache_nodes            = 1
  parameter_group_name       = "default.redis7"
  port                       = 6379
  subnet_group_name          = aws_elasticache_subnet_group.redis_subnet_group.name
  security_group_ids         = ["sg-0197fdecc5f3c5fd8"] # Replace with the live SG Id
  maintenance_window         = "wed:03:00-wed:04:00"
  snapshot_retention_limit   = 1
  snapshot_window            = "01:30-02:30"
  auto_minor_version_upgrade = false
  availability_zone          = "us-east-2b" # Replace with your desired availability zone
  ip_discovery               = "ipv4"
  network_type               = "ipv4"
  transit_encryption_enabled = false
}
