variable "cidr" {
    description = "Subnet CIDR Range"
    default = "10.0.0.0/16"
  
}

variable "subnet1_cidr" {
    description = "Subnet 1 CIDR Range"
    default = "10.0.0.0/24"
}
variable "subnet2_cidr" {
    description = "Subnet 2 CIDR Range"
    default = "10.0.1.0/24"
}
variable "availability_zone-1a" {
    description = "Availability Zone"
    default = "ap-south-1a" 
}
variable "availability_zone-1b" {
    description = "Availability Zone"
    default = "ap-south-1b" 
}

# Define an input variable for the EC2 instance type
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

# Define an input variable for the EC2 instance AMI ID
variable "ami_id" {
  description = "EC2 AMI ID"
  type        = string
  default = "ami-007020fd9c84e18c7"
}
