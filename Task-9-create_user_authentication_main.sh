#!/bin/bash
userName=$2
# Check if file with list of servers is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <servers_file>"
  exit 1
fi

# Read servers from file
servers_file=$1
if [ ! -f "$servers_file" ]; then
  echo "The provided file does not exist: $servers_file"
  exit 1
fi
# Ask for authentication type
echo "Choose authentication method for user '$userName':"
echo "1) Password-based authentication"
echo "2) Key-based authentication"
read -p "Enter your choice (1 or 2): " auth_choice

if [[ "$auth_choice" -eq 1 ]]; then
  # Password-based authentication
  read -sp "Enter password for user '$userName': " password
  read -p "Enter the full path to your SSH private key: " ssh_key_path
  echo
  password_based=true
elif [[ "$auth_choice" -eq 2 ]]; then
  # Key-based authentication
  read -p "Enter the full path to your SSH private key: " ssh_key_path
  if [ ! -f "$ssh_key_path" ]; then
    echo "Invalid SSH key path: $ssh_key_path"
    exit 1
  fi
  key_based=true
else
  echo "Invalid choice, exiting."
  exit 1
fi

for server in $(cat server_list)
do
	echo "******************$server*****************"
		if [ "$key_based" = true ]; then
			ssh -i $ssh_key_path ec2-user@$server "/bin/bash -s" < /root/keybased_authentication.sh $userName
			ssh -i $ssh_key_path $userName@$server "exit"
			if [ $? -eq 0 ]; then
				echo "User $userName added on $server"
			else
				echo "Error on $server"
			fi
		fi
	if [ "$password_based" = true ]; then

			ssh -i $ssh_key_path ec2-user@$server "/bin/bash -s"  < /root/password_authentication.sh $userName $password
			if [ $? -eq 0 ]; then
				echo "User $userName added on $server with password based authentication"
			else
				echo "Error on $server"
			fi
	fi
done




                      
