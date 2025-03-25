#!/bin/bash
user=$1
sudoers_config="/etc/sudoers"
line_to_add="$user ALL=(ALL) NOPASSWD: ALL"
echo "$line_to_add" | sudo tee -a /etc/sudoers > /dev/null

# Check the syntax of the sudoers file (visudo does this automatically)
sudo visudo -c

# Confirm the line was added
echo "Line added to /etc/sudoers."
#sudo cat $allow_user_sudo >> $sudoers_config
