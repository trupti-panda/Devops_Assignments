#!/bin/bash
username=$1
ssh_key_path="/home/ec2-user/.ssh/authorized_keys"
#sudo su -
# Check if the user exists using the `id` command
if id "$username" &>/dev/null; then
        echo "User '$username' exists."
else
        echo "User '$username' does not exist. Creating user .."
        sudo useradd -m -s /bin/bash $username
        sudo mkdir -p /home/$username/.ssh
        sudo cp $ssh_key_path /home/$username/.ssh/
        sudo chmod 700 /home/$username/.ssh
        sudo chmod 600 /home/$username/.ssh/authorized_keys
        sudo chown -R $username:$username /home/$username/.ssh
        sudo usermod -aG wheel $username
        echo "User $username created with key-based authentication ."
fi
