# Template File for WordPress user data


data "template_file" "wordpress_user_data" {
	template = file("${path.module}/wordpress_user_data.sh.tpl")

	vars = {
		rds_endpoint            = aws_db_instance.My_rds_mysql.endpoint
		adminpassword           = var.db_password
		username                = var.db_user_name
		db_name                 = var.db_name
		wp_title                = var.wordpress_site_title
		wp_user                 = var.wordpress_admin_user
		wp_pass                 = var.wordpress_admin_password
		wp_email                = var.wordpress_admin_email
	}
}

