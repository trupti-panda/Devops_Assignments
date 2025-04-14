variable "vpc_name" {}
variable "vpc_cidr_block" {}
variable "subnet_cidr_blocks" {
  description = "List of subnet CIDR blocks for public and private subnets"
  type        = list(string)
  default = [
    "10.0.1.0/24",  # Public LB Subnet 1
    "10.0.2.0/24",  # Public LB Subnet 2
    "10.0.3.0/24",  # Public LB Subnet 3
    "10.0.4.0/24",  # Private Application Subnet 1
    "10.0.5.0/24",  # Private Application Subnet 2
    "10.0.6.0/24",  # Private Application Subnet 3
    "10.0.7.0/24",  # Private Database Subnet 1
    "10.0.8.0/24",  # Private Database Subnet 2
    "10.0.9.0/24"   # Private Database Subnet 3
  ]
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-west-2a", "us-west-2b", "us-west-2c"]
}



#####RDS variables
variable "db_storage" {
	type = number
}
variable "db_name" {}
variable "instance_class" {}
variable "db_user_name" {}
variable "db_password" {}
variable "db_subnet_group_name" {}
variable "db_storage_type" {}
variable "db_identifier" {}


######Jump subnet
variable "jump_subnet_cidr" {}
variable "jump_subnet_az" {}
variable "jump_subnet_name" {}

#######JUmp HOst
variable "jump_ami_id" {} 
variable "jump_instance_type" {}
variable "jump_host_name" {}


variable "key_name" {}
variable "instance_type" {}

#####Wordpress details
variable "wordpress_site_title" {}
variable "wordpress_admin_user" {}
variable "wordpress_admin_password" {}
variable "wordpress_admin_email" {}
