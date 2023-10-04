provider "aws" {
  region = "us-east-1"
  access_key = ""
  secret_key = ""
}

// Create an Vpc
resource "aws_vpc" "vpc" {
    cidr_block = "192.168.0.0/16"
}

// Create an Public Subnet 
resource "aws_subnet" "publicsubnet" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "192.168.10.0/24"
    availability_zone = "us-east-1a"
}

// Create an Private Subnet 
resource "aws_subnet" "privatesubnet" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "192.168.20.0/24"
    availability_zone = "us-east-1b"
}

// Create an Internet Gateway 
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id
}

// Create an Nat Gateway 
resource "aws_eip" "nateip" {}

resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.nateip.id
  subnet_id     = aws_subnet.publicsubnet.id
}


// Create an Public RouteTable
resource "aws_route_table" "publicroutetable" {
    vpc_id = aws_vpc.vpc.id
}

// Create an Private RouteTable
resource "aws_route_table" "privateroutetable" {
    vpc_id = aws_vpc.vpc.id
}

// Create an public Route 
resource "aws_route" "publicroute" {
    route_table_id = aws_route_table.publicroutetable.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
}

// Create an Private Route 
resource "aws_route" "privateroute" {
    route_table_id = aws_route_table.privateroutetable.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw.id
}


// Create an Public RouteTable Association 
resource "aws_route_table_association" "publicasso" {
    route_table_id = aws_route_table.publicroutetable.id
    subnet_id = aws_subnet.publicsubnet.id
}

// Create an Private RouteTable Assocaition
resource "aws_route_table_association" "privateasso" {
    route_table_id = aws_route_table.privateroutetable.id
    subnet_id = aws_subnet.privatesubnet.id
}


// Create an Secruity Group for Public Instance 
resource "aws_security_group" "publicsg" {
    name = "publicsg"
    vpc_id = aws_vpc.vpc.id
    description = "Allow traffic for the Public Instance"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0 
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

// Create an Secuirty Group Private Instance 
resource "aws_security_group" "privatesg" {
    name = "privatesg"
    vpc_id = aws_vpc.vpc.id
    description = "Allow Traffic for the Private Instance"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "tcp"
        cidr_blocks =["0.0.0.0/0"]
    }
}

// // Create an Ec2 for the Public Instance 
resource "aws_instance" "publicinstance" {
    ami = "ami-053b0d53c279acc90"
    instance_type = "t2.micro"
    key_name = "demo"
    private_ip = "192.168.10.10"
    associate_public_ip = true
    subnet_id = aws_subnet.publicsubnet.id
    vpc_security_group_ids = [aws_security_group.publicsg.id]
}

// Create an EC2 for the Private Subnet
resource "aws_instance" "privateinstance" {
    ami =  "ami-053b0d53c279acc90"
    instance_type = "t2.micro"
    key_name = "private"
    private_ip = "192.168.20.20"
    associate_public_ip = false 
    subnet_id = aws_subnet.privatesubnet.id
    vpc_security_group_ids = [aws_security_group.privatesg.id]

    user_data = <<-EOF
    #!/bin bash 

    # update 
    sudo apt update 

    #Install docker 
    apt install docker.io -y 
    EOF
}
