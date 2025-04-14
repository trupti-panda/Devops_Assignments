vpc_cidr_block = "10.0.0.0/16"
vpc_name = "VPC-13"
db_storage = 20
db_name = "myRDSdb"
instance_class = "t3.micro"
db_user_name = "admin"
db_password = "admin1234"
db_subnet_group_name = "my_rds_subnet_group"
db_storage_type = "gp2"
db_identifier = "wordpress-db"

jump_subnet_cidr = "10.0.10.0/24" #public jump subnet
jump_subnet_az = "us-west-2a"
jump_subnet_name = "jump_sub"

jump_ami_id = "ami-0520f976ad2e6300c"
jump_instance_type = "t2.micro"
jump_host_name = "JUMPHOST"
key_name = "MC-PUBLIC"
instance_type = "t2.micro"


wordpress_site_title = "My-WordPress"
wordpress_admin_user = "admin"
wordpress_admin_password = "admin1234"
wordpress_admin_email = "abc@xyz.com"
