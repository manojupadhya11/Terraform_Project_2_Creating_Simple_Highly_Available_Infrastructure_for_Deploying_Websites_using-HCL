resource "aws_vpc" "my_vpc" {
    cidr_block = var.cidr
}

resource "aws_subnet" "Subnet-1a" {
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = var.subnet1_cidr
    availability_zone = var.availability_zone-1a
    map_public_ip_on_launch =  true
}
resource "aws_subnet" "Subnet-1b" {
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = var.subnet2_cidr
    availability_zone = var.availability_zone-1b
    map_public_ip_on_launch = true  
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.my_vpc.id
}

resource "aws_route_table" "RT" {
    vpc_id = aws_vpc.my_vpc.id

    route = {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
  
}
resource "aws_route_table_association" "rta1" {
    subnet_id = aws_subnet.Subnet-1a.id
    route_table_id = aws_route_table.RT.id
}
resource "aws_route_table_association" "rta2" {
    subnet_id = aws_subnet.Subnet-1b.id
    route_table_id = aws_route_table.RT.id
}

resource "aws_security_group" "WebSG" {
    name = "web"
    vpc_id = aws_vpc.my_vpc.id

    ingress {
        description = "HTTP from VPC"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "ssh"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress = {
        description = "everywhere"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "web-sg"
    }
  
}

#First Web Server on one of the subnet
resource "aws_instance" "webserver1" {
    ami = var.ami_id
    instance_type = var.instance_type
    vpc_security_group_ids = [ aws_security_group.WebSG.id ]
    subnet_id = aws_subnet.Subnet-1a.id
    user_data = base64encode("userdata.sh")
    associate_public_ip_address = true  
}
resource "aws_instance" "webserver2" {
    ami = var.ami_id
    instance_type = var.instance_type
    vpc_security_group_ids = [ aws_security_group.WebSG.id ]
    subnet_id = aws_subnet.Subnet-1b.id
    user_data = base64encode("userdata.sh")
    associate_public_ip_address = true
  
}


#Code for Creating Application Load Balancer
resource "aws_alb" "myalb" {
    name = "myalb"
    internal = false
    load_balancer_type = "application"
    security_groups = [aws_security_group.WebSG.id]
    subnets = [aws_subnet.Subnet-1a.id , aws_subnet.Subnet-1b.id]

    tags = {
      name = "web"
    }
  
}

#Create ALB Target Group