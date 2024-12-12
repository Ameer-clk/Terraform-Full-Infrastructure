resource "aws_elasticache_subnet_group" "tfer--redis-subnet-group" {
  description = " "
  name        = "redis-subnet-group"
  subnet_ids  = ["subnet-004ebc08c013ce21e", "subnet-04a450459b634d062", "subnet-064081762c2219bdf", "subnet-06b40c45edc10bc4c", "subnet-0cc978cc7e926dfc8", "subnet-0e8134a55c850397d"] #Replace with actuall 6 subnet ids
}
