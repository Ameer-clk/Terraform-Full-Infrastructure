provider "aws" {
    region = "us-east-1"
    access_key = ""
    secret_key = ""
}

// Create a Vpc Grafana
resource "aws_vpc" "grafanavpc" {
    cidr_block = "172.16.0.0/16"    # Give your desired Ip address 
}

// Create a Vpc for Jenkins
resource "aws_vpc" "jenkinsvpc" {
     cidr_block = "172.17.0.0/16"
}

// Create a Subnet for Grafana 
resource "aws_subnet" "grafanasubnet" {
    vpc_id = aws_vpc.grafanavpc.id
    cidr_block = "172.16.10.0/24"
    availability_zone = "us-east-1a"  # Give your desired zone 
}

// Create a Subnet for the Jenkins 
resource "aws_subnet" "jenkinssubnet" {
    vpc_id = aws_vpc.jenkinsvpc.id
    cidr_block = "172.17.10.0/24"
    availability_zone = "us-east-1b"
}

// Create a Internet Gateway for Grafana
resource "aws_internet_gateway" "grafanaigw" {
    vpc_id = aws_vpc.grafanavpc.id
}

// Create a Internet Gateway for Jenkins 
resource "aws_internet_gateway" "jenkinsigw" {
     vpc_id = aws_vpc.jenkinsvpc.id
}

// Create a RouteTable for Grafana 
resource "aws_route_table" "grafanaroutetable" {
    vpc_id = aws_vpc.grafanavpc.id
}

// Create a RouteTable for Jenkins 
resource "aws_route_table" "jenkinsroutetabale" {
    vpc_id = aws_vpc.jenkinsvpc.id
}

// Create a Route Table Association for grafana 
resource "aws_route_table_association" "grafanaroutetableassociation" {
    route_table_id = aws_route_table.grafanaroutetable.id
    subnet_id = aws_subnet.grafanasubnet.id
}

// Create a RouteTable Association for Jenkins 
resource "aws_route_table_association" "jenkinsroutetableassociation" {
    route_table_id = aws_route_table.jenkinsroutetabale.id
    subnet_id = aws_subnet.jenkinssubnet.id
}

// Create a Route for Grafana  
resource "aws_route" "grafanaroute" {
    route_table_id = aws_route_table.grafanaroutetable.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.grafanaigw.id   
}

// Create a Route for Jenkins 
resource "aws_route" "jenkinsroute" {
     route_table_id = aws_route_table.jenkinsroutetabale.id
     destination_cidr_block = "0.0.0.0/0"
     gateway_id = aws_internet_gateway.jenkinsigw.id
}

// Create a Security Group for the Grafana Instance 
resource "aws_security_group" "grafanasg" {
  name        = "grafanasg"
  description = "Security group for Grafana Instance"
  vpc_id      = aws_vpc.grafanavpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks  = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks  = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9115
    to_port     = 9115
    protocol    = "tcp"
    cidr_blocks  = ["0.0.0.0/0"] 
  }

  ingress {
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks  = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

// Create a Security Group for Jenkins Instance 
resource "aws_security_group" "jenkinssg" {
   name        = "jenkinssg"
  description = "Security group for Jenkins Instance"
  vpc_id      = aws_vpc.jenkinsvpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080 
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol =  "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
     
}

// Create an Instance for Grafana Server
resource "aws_instance" "grafanainstance" {
  ami           = "image id"          # Give your desired AMI Image
  instance_type = "t2.micro"          # Give your desired Instance type 
  key_name      = "demo"              # Give your desired keyname
  associate_public_ip_address = true
  private_ip    = "172.16.10.10"
  subnet_id     = aws_subnet.grafanasubnet.id
  vpc_security_group_ids = [aws_security_group.grafanasg.id]

  user_data = <<-EOF
    #!/bin/bash

    # Update the package manager
    sudo apt-get update

    # Install required dependencies
    sudo apt-get install -y curl conntrack jq

    # Install Docker
    sudo apt-get install -y docker.io

    # Clone the Github Repo 
    git clone https://github.com/Ameer-clk/monitoring-iinerds.git

    # Install Minikube
    curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    chmod +x minikube
    sudo mv minikube /usr/local/bin/

    # Install kubectl
    curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
    chmod +x kubectl
    sudo mv kubectl /usr/local/bin/

    # Start Minikube
    minikube start --driver=none

    # Install Ansible 
    
# Check if Ansible is already installed
if command -v ansible &> /dev/null; then
    echo "Ansible is already installed."
    exit 0
fi

# Check if the system is YUM-based or APT-based
if command -v yum &> /dev/null; then
    echo "Detected YUM-based system. Installing Ansible..."
    sudo yum -y install epel-release
    sudo yum -y install ansible
elif command -v apt-get &> /dev/null; then
    echo "Detected APT-based system. Installing Ansible..."
    sudo apt-get update
    sudo apt-get -y install software-properties-common
    sudo apt-add-repository --yes --update ppa:ansible/ansible
    sudo apt-get -y install ansible
else
    echo "Unsupported package manager. Please install Ansible manually."
    exit 1
fi

# Verify Ansible installation
if command -v ansible &> /dev/null; then
    echo "Ansible installation successful."
else
    echo "Failed to install Ansible."
    exit 1
fi
  EOF
}

// Create an Instance for Jenkins server 
resource "aws_instance" "jenkinsinstance" {
  ami           = "image id"
  instance_type = "t2.small"
  key_name      = "demo"
  associate_public_ip_address = true
  private_ip    = "172.17.10.20"
  subnet_id     = aws_subnet.jenkinssubnet.id
  vpc_security_group_ids = [aws_security_group.jenkinssg.id]   

 user_data = <<-EOF
#!/bin/bash

# Update the Server
sudo apt update -y

# Install Docker
sudo apt install docker.io -y

# Pull the Jenkins Docker image
sudo docker pull jenkins:jenkins

# Run Jenkins as a Docker container
sudo docker run -d -p --name jenkins -p 8080:8080 jenkins:jenkins
EOF 
}


  



