#!/bin/bash

# Redirect all output to log file
exec > >(tee -a /var/log/user-data.log | logger -t user-data -s 2>/dev/console) 2>&1

echo "=== Starting WordPress EC2 setup ==="

# Update and install dependencies
yum update -y
yum remove -y php*
amazon-linux-extras enable php8.1
yum clean metadata
yum install -y php php-mysqlnd php-fpm php-gd php-xml php-mbstring php-json php-opcache httpd wget

# Start Apache
systemctl start httpd
systemctl enable httpd

# Download and extract WordPress
cd /var/www/html
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
cp -r wordpress/* .
rm -rf wordpress latest.tar.gz
cp wp-config-sample.php wp-config.php

# Set permissions
chown -R apache:apache /var/www/html
chmod -R 755 /var/www/html

# Install WP-CLI
echo "[INFO] Downloading WP-CLI..."
#cd /tmp
wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

if [ -f wp-cli.phar ]; then
  chmod +x wp-cli.phar
  mv wp-cli.phar /usr/local/bin/wp
  echo "[INFO] WP-CLI installed at /usr/local/bin/wp"
else
  echo "[ERROR] wp-cli.phar download failed!"
  exit 1
fi

# Verify WP-CLI works
/usr/local/bin/wp --info || {
  echo "[ERROR] wp command not working!"
  exit 1
}

# Replace placeholders in wp-config.php
sed -i "s/database_name_here/${db_name}/" wp-config.php
sed -i "s/username_here/${username}/" wp-config.php
sed -i "s/password_here/${adminpassword}/" wp-config.php
sed -i "s/localhost/${rds_endpoint}/" wp-config.php

# Install WordPress with WP-CLI
cd /var/www/html

/usr/local/bin/wp core install \
  --url="http://localhost" \
  --title="${wp_title}" \
  --admin_user="${wp_user}" \
  --admin_password="${wp_pass}" \
  --admin_email="${wp_email}" \
  --path="/var/www/html" \
  --skip-email \
  --allow-root

# Restart Apache
systemctl restart httpd

echo "=== WordPress setup complete ==="

