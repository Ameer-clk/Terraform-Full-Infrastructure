config = {
    "provider": {
        "aws": {
            "region": "us-east-1"  # Give your desired region
            # Use your private access key
            # Use your secret access key
        }
    },
    "resource": {
        "aws_vpc": {
            "example_vpc": {
                "cidr_block": "10.1.0.0/16"
            }
        },
        "aws_subnet": {
            "publicsubnet": {
                "vpc_id": "aws_vpc.example_vpc.id",
                "cidr_block": "10.1.10.0/24",
                "availability_zone": "us-east-1a"
            },
            "privatesubnet": {
                "vpc_id": "aws_vpc.example_vpc.id",
                "cidr_block": "10.1.20.0/24",
                "availability_zone": "us-east-1b"
            },
            "privatesubnet1": {
                "vpc_id": "aws_vpc.example_vpc.id",
                "cidr_block": "10.1.30.0/24",
                "availability_zone": "us-east-1c"
            }
        },
        "aws_route_table": {
            "publicroutetable": {
                "vpc_id": "aws_vpc.example_vpc.id"
            },
            "privateroutetable": {
                "vpc_id": "aws_vpc.example_vpc.id"
            },
            "privateroutetable1": {
                "vpc_id": "aws_vpc.example_vpc.id"
            }
        },
        "aws_route": {
            "publicroute": {
                "route_table_id": "aws_route_table.publicroutetable.id",
                "destination_cidr_block": "0.0.0.0/0",
                "gateway_id": "aws_internet_gateway.myigw.id"
            },
            "privatecroute": {
                "route_table_id": "aws_route_table.privateroutetable.id",
                "destination_cidr_block": "0.0.0.0/0",
                "gateway_id": "aws_internet_gateway.myigw.id"
            },
            "publicroute1": {
                "route_table_id": "aws_route_table.privateroutetable1.id",
                "destination_cidr_block": "0.0.0.0/0",
                "gateway_id": "aws_internet_gateway.myigw.id"
            }
        },
        "aws_route_table_association": {
            "publicassociation": {
                "subnet_id": "aws_subnet.publicsubnet.id",
                "route_table_id": "aws_route_table.publicroutetable.id"
            },
            "privatecassociation": {
                "subnet_id": "aws_subnet.privatesubnet.id",
                "route_table_id": "aws_route_table.privateroutetable.id"
            },
            "privatecassociation1": {
                "subnet_id": "aws_subnet.privatesubnet1.id",
                "route_table_id": "aws_route_table.privateroutetable1.id"
            }
        },
        "aws_internet_gateway": {
            "myigw": {
                "vpc_id": "aws_vpc.example_vpc.id"
            }
        },
        "aws_security_group": {
            "example_sg": {
                "name": "my-sg",
                "description": "For the infra",
                "vpc_id": "aws_vpc.example_vpc.id",
                "ingress": [
                    {
                        "from_port": 22,
                        "to_port": 22,
                        "protocol": "tcp",
                        "cidr_blocks": ["10.1.0.0/0"]
                    }
                ],
                "egress": [
                    {
                        "from_port": 0,
                        "to_port": 0,
                        "protocol": "-1",
                        "cidr_blocks": ["0.0.0.0/0"]
                    }
                ]
            }
        },
        "aws_ebs_volume": {
            "myebs": {
                "availability_zone": "us-east-1a",
                "size": 8,
                "encrypted": True,
                "tags": {
                    "Name": "Example EBS Volume"
                }
            }
        },
        "aws_ebs_snapshot": {
            "mysnapshot": {
                "volume_id": "aws_ebs_volume.myebs.id",
                "tags": {
                    "Name": "Example Snapshot"
                }
            }
        },
        "aws_ami": {
            "example": {
                "name": "terraform-example",
                "virtualization_type": "hvm",
                "root_device_name": "/dev/xvda",
                "imds_support": "v2.0",
                "ebs_block_device": [
                    {
                        "device_name": "/dev/xvda",
                        "snapshot_id": "aws_ebs_snapshot.mysnapshot.id",
                        "volume_size": 8
                    }
                ]
            }
        },
        "aws_launch_template": {
            "mytemplate": {
                "name": "example-launch-template",
                "image_id": "ami-0f34c5ae932e6f0e4",  # Replace with the desired AMI ID
                "instance_type": "t2.micro",
                "vpc_security_group_ids": ["aws_security_group.example_sg.id"]
            }
        },
        "aws_lb_target_group": {
            "newtarget_group": {
                "name": "newtarget-group",
                "port": 80,
                "protocol": "HTTP",
                "vpc_id": "aws_vpc.example_vpc.id"
            }
        },
        "aws_lb": {
            "newalb": {
                "name": "new-alb",
                "internal": True,
                "drop_invalid_header_fields": True,
                "load_balancer_type": "application",
                "security_groups": ["aws_security_group.example_sg.id"],
                "subnets": ["aws_subnet.privatesubnet1.id", "aws_subnet.privatesubnet.id"]
            }
        },
        "aws_lb_listener": {
            "mylistener": {
                "load_balancer_arn": "aws_lb.newalb.arn",
                "port": 80,
                "protocol": "HTTP",
                "default_action": [
                    {
                        "target_group_arn": "aws_lb_target_group.newtarget_group.arn",
                        "type": "forward"
                    }
                ]
            }
        },
        "aws_autoscaling_group": {
            "myaug": {
                "name": "myaug",
                "launch_template": [
                    {
                        "id": "aws_launch_template.mytemplate.id",
                        "version": "$Latest"
                    }
                ],
                "target_group_arns": ["aws_lb_target_group.newtarget_group.arn"],
                "vpc_zone_identifier": [
                    "aws_subnet.privatesubnet.id",
                    "aws_subnet.privatesubnet1.id"
                ],
                "min_size": 1,
                "max_size": 2,
                "desired_capacity": 1,
                "health_check_type": "ELB"  # Use "EC2" for EC2 instance health check
            }
        }
    }
}
