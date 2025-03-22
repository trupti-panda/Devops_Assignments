#!/bin/bash
# Path to the SSH config file
sshd_config="/etc/ssh/sshd_config"
change_parameter=("PermitRootLogin" "PasswordAuthentication" "ChallengeResponseAuthentication")
# Check if the file exists
if [ ! -f "$sshd_config" ]; then
  echo "The file $sshd_config does not exist!"
  exit 1
fi
username=$1
if id "$username" &>/dev/null; then
	echo "User '$username' exists."
	exit
else
	
	sudo cat $sshd_config > $sshd_config.bakup
	for item in "${change_parameter[@]}"; do

		# Check if $item is set to 'No'
		if sudo grep -q "^$item" "$sshd_config"; then
		  # If found, check if it's set to 'No'
			current_setting=$(sudo grep "^$item" "$sshd_config" | awk '{print $2}')

				if [ "$current_setting" == "no" ]; then
					echo "$item is set to 'No'. Changing it to 'Yes'..."

					# Update the line in the file
					echo "==================="
					sudo sed -i "s/^$item no/$item yes/" "$sshd_config"
					echo "$item has been set to 'Yes'"
				elif [ "$current_setting" == "yes" ] ; then
					echo "$item is already set to 'Yes'."
				fi
		else
			# If $item line doesn't exist, add it with 'yes'
			echo "$item is not found. Adding '$item yes'..."
			echo "$item yes" | sudo tee -a "$sshd_config" > /dev/null
			echo "$item has been set to 'Yes' ."
		fi
	done
	echo "User '$username' does not exist. Creating user .."
	sudo useradd -m -s /bin/bash $username
	PASSWORD=$2  
	echo "Setting password for user '$username'..."
	echo "$PASSWORD" | sudo passwd --stdin $username
	sudo usermod -aG wheel $username

	# Restart the SSH service to apply changes
	echo "Restarting SSH service..."
	sudo systemctl restart sshd
	sleep 5
fi
