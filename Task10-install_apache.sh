#!/bin/bash

# Check if Apache is installed
if ! command -v apachectl &>/dev/null; then
    echo "Apache is not installed. Installing Apache..."
        sudo yum update -y
        sudo yum install -y httpd
    # Enable Apache to start on boot
    sudo systemctl enable httpd
    # Start Apache
    sudo systemctl start httpd
    sudo systemctl status httpd
    if [ $? -eq 0 ]; then
        echo "Apache has been installed and started."
    else
        echo "Apache installation failed"
    fi
else
    echo "Apache is already installed."
fi
